import asyncio
import aiohttp
import streamlit as st
from apscheduler.schedulers.background import BackgroundScheduler
from tenacity import retry, stop_after_attempt, wait_exponential
from datetime import datetime
import json

# Password Protection for the UI
def check_password():
    if 'password_entered' not in st.session_state:
        st.session_state.password_entered = False
    
    if not st.session_state.password_entered:
        password = st.text_input("Enter Password", type="password")
        if password == "@EmailTool123":
            st.session_state.password_entered = True
        else:
            st.error("Incorrect Password")
        return False
    return True

# Retry Mechanism with Exponential Backoff
@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=1, max=5))
async def send_request(session, url, data, proxy=None):
    try:
        async with session.post(url, data=data, proxy=proxy) as response:
            if response.status == 200:
                return True
            return False
    except Exception as e:
        return False

# Main asynchronous function to send requests
async def run_async_requests(num_requests, url, data, proxies, webhook_url):
    success_count = 0
    fail_count = 0
    
    # Setup session with aiohttp
    async with aiohttp.ClientSession() as session:
        tasks = []
        for i in range(num_requests):
            proxy = proxies[i % len(proxies)] if proxies else None
            tasks.append(send_request(session, url, data, proxy))
        
        # Run tasks and collect results
        results = await asyncio.gather(*tasks)

        for result in results:
            if result:
                success_count += 1
            else:
                fail_count += 1

    # Display final counts
    st.write(f"Total Successes: {success_count}")
    st.write(f"Total Failures: {fail_count}")

    # Trigger webhook
    if webhook_url:
        webhook_data = {
            'success_count': success_count,
            'fail_count': fail_count,
            'timestamp': datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        }
        await send_webhook_notification(webhook_url, webhook_data)

# Webhook notification function
async def send_webhook_notification(webhook_url, data):
    async with aiohttp.ClientSession() as session:
        await session.post(webhook_url, json=data)

# Schedule the task
def schedule_requests(num_requests, num_threads, url, data, proxies, webhook_url, run_time):
    scheduler = BackgroundScheduler()
    scheduler.add_job(lambda: asyncio.run(run_async_requests(num_requests, url, data, proxies, webhook_url)), 'date', run_date=run_time)
    scheduler.start()

# Streamlit UI
if check_password():
    st.title("Asynchronous Requests Tool with Proxy, Retry, and Webhook Support")

    # Input fields
    email = st.text_input("Enter your email", "")
    webhook_url = st.text_input("Webhook URL for notifications", "")
    proxy_list = st.text_area("Enter Proxies (one per line)", "").split("\n")
    num_requests = st.number_input("Number of requests", min_value=1, max_value=1000, value=100)
    run_time = st.text_input("Run at (YYYY-MM-DD HH:MM:SS) or leave blank for immediate start", "")
    
    # URL and data for the POST request
    url = 'https://70games.net/user-send_code-user_create.htm'
    data = {
        'username': 'hdjdjd',
        'password': email,  # Using email as password for demo purposes
        'inviter': '',
        'email': email,
        'code': '',
    }

    # Start button logic
    if st.button("Start Requests"):
        if email:
            if run_time:
                try:
                    # Schedule the requests
                    run_time_dt = datetime.strptime(run_time, "%Y-%m-%d %H:%M:%S")
                    schedule_requests(num_requests, len(proxy_list), url, data, proxy_list, webhook_url, run_time_dt)
                    st.success(f"Requests scheduled for {run_time_dt}")
                except ValueError:
                    st.error("Invalid date/time format. Please use YYYY-MM-DD HH:MM:SS")
            else:
                # Run requests immediately
                asyncio.run(run_async_requests(num_requests, url, data, proxy_list, webhook_url))
                st.success("Requests started!")
        else:
            st.error("Please enter a valid email.")
