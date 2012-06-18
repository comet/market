#Run the rails runner command every minute
echo "Moving into the routine folder"
cd /home/slowcoach/codecamp/rails/kassi/

echo "Preparing to run the message fetch job" 

rvm use 1.8.7
rvm gemset use kassinew

rails runner lib/MessageFetch.rb >>fetch_messages.log

echo "Completed the message fetching routine" 
