const handler = async () => {
    return {
        statusCode: 200,
        body: {
            hello: "world"
        }
    };
}

module.exports = {
    handler
}
