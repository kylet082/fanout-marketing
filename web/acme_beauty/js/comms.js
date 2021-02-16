const store = 'acme_beauty';
const endpoint = 'APIGW_URL';
//const cors = 'https://cors-anywhere.herokuapp.com';

function send_data (form){
  form.append('company', store);

  const res = fetch(endpoint+'/invoker',
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