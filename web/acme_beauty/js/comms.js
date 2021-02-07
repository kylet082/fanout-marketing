const store = 'acme_beauty';
const endpoint = 'APIGW_URL';
const cors = 'https://cors-anywhere.herokuapp.com';

function send_data (form){
    console.log("in send : " + form)
    
    //   const form = new FormData();
      form.append('company', store);

      const res = fetch(cors + '/' + endpoint+'/invoker',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(Object.fromEntries(form))
        }
      ).then(response => {
        if (response.ok) {
          window.location.replace('thankyou.html');
        }
      });
}