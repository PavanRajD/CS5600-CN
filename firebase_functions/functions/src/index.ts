const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

function setDateTime(date: any, time: any) {
    var index = time.indexOf(":");
    var hours = time.substring(0, index);
    var minutes = time.substring(index + 1, time.length);
    date.setHours(hours);
    date.setMinutes(minutes);
    date.setSeconds("00");
    return date;
}

exports.sendNotification = functions.firestore
    .document('messages/{groupId1}/{groupId2}/{message}')
    .onCreate((snap: { data: () => any }, context: any) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)

        const idFrom = doc.idFrom
        const idTo = doc.idTo
        const contentMessage = doc.content

        // Get push token user to (receive)
        admin
            .firestore()
            .collection('users')
            .where('id', '==', idTo)
            .get()
            .then((querySnapshot: any[]) => {
                querySnapshot.forEach(userTo => {
                    console.log(`Found user to: ${userTo.data().nickname}`)

                    if (userTo.data().pushToken && userTo.data().chattingWith !== idFrom) {
                        // Get info user from (sent)
                        admin
                            .firestore()
                            .collection('users')
                            .where('id', '==', idFrom)
                            .get()
                            .then((querySnapshot2: any[]) => {
                                querySnapshot2.forEach(userFrom => {
                                    console.log(`Found user from: ${userFrom.data().nickname}`)
                                    var currentDate = new Date()
                                    var startDate = setDateTime(new Date(), userTo.data().notAvilableStartTime)
                                    var endDate = setDateTime(new Date(), userTo.data().notAvilableEndTime)
                                    var isValidTime = (startDate < currentDate && endDate > currentDate) ?? true
                                    console.log(setDateTime(new Date(), userTo.data().notAvilableStartTime))
                                    console.log(setDateTime(new Date(), userTo.data().notAvilableEndTime))

                                    var canSendPush = isValidTime && (userTo.data().isDNDActivated == 'false') || (userTo.data().overrideContacts && userTo.data().overrideContacts.includes(idFrom))

                                    if (canSendPush) {
                                        const payload = {
                                            notification: {
                                                title: `"${userFrom.data().nickname}"`,
                                                body: contentMessage,
                                                badge: '1',
                                                sound: 'default'
                                            }
                                        }

                                        // Let push to the target device
                                        admin
                                            .messaging()
                                            .sendToDevice(userTo.data().pushToken, payload)
                                            .then((response: any) => {
                                                console.log('Successfully sent message:', response)
                                            })
                                            .catch((error: any) => {
                                                console.log('Error sending message:', error)
                                            })
                                    } else {
                                        var groupChatId = ''
                                        if (idFrom.localeCompare(idTo) > 0) {
                                            groupChatId = `${idFrom}-${idTo}`;
                                        } else {
                                            groupChatId = `${idTo}-${idFrom}`;
                                        }

                                        console.log(`groupChatId : ${groupChatId}`)

                                        admin
                                            .firestore()
                                            .collection('messages')
                                            .doc(groupChatId)
                                            .collection(groupChatId)
                                            .doc(Date.now().toString())
                                            .set({
                                                idFrom: idTo,
                                                idTo: idFrom,
                                                timestamp: Date.now().toString(),
                                                content: `${userTo.data().nickname} is unavailable. Status: ${userTo.data().aboutMe}`,
                                                type: 0,
                                            });
                                    }
                                })
                            })
                    } else {
                        console.log('Unable to send to target user')
                    }
                })
            })
        return null
    })