const store = 'acme_beauty';
const endpoint = 'APIGW_URL'

document.getElementById('user-form').onsubmit = async function (e) {
    e.preventDefault();
    // here `this` is the user-form HTML element
    const form = new FormData(this);
    form.append('company' , store);

    const res = await fetch(endpoint ,
      {
            method: 'POST',
            mode: 'no-cors',
            headers: {
              'content-type': 'application/json',
            },
            body: JSON.stringify(Object.fromEntries(form))
       }
    );

    console.log(res);
};


