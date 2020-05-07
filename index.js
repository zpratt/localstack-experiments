const handler = (event, context, callback) => {
    console.log('hello world');

    return callback(null, {
        statusCode: 200,
        body: JSON.stringify({
            hello: "world"
        })
    });
}

module.exports = {
    handler
}

// http://localhost:4567/restapis/
// can probably do some jq magic to rip the id off the response and build the actual URL
// http://localhost:4567/restapis/{id}/local/_user_request_/hello-world