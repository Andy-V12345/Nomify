const functions = require('firebase-functions')
require('dotenv').config()
const API_KEY = process.env.API_KEY
const { GoogleGenerativeAI } = require("@google/generative-ai")

const genAI = new GoogleGenerativeAI(API_KEY)
const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" })

exports.analyzeFoodImage = functions.https.onRequest(async (req, res) => {
    const data = req.body

    const prompt = `What food item is this image? If it's a food product also tell me what it is. Please be as specific as possible. If you cannot identify an individual food item, list out as many food items as you can. For example, if you see bowl with rice, beans, and chicken and you can't recognize it as a single food item, return it as "rice, beans, and chicken". You must return a JSON object with the following format: 
        foodItem: name of food item or food product

    If you cannot identify a food item or a food product from the image, you must return a JSON object with the following format:
        error: "No food identified"

    In the JSON response, do not include the \`\`\`json in the beginning and the \`\`\` at the end.
    `

    const imagePart = {
        inlineData: {
            data: data.encodedImage,
            mimeType: "image/jpeg"
        }
    }

    const result = await model.generateContent([prompt, imagePart])
    const response = result.response;
    const text = response.text()

    res.status(200).send({
        msg: text
    })
})