builder = require 'botbuilder'
prompts = require '../prompts'
modelConfig = require '../../../config/model-config'


modelUrl = "https://api.projectoxford.ai/luis/v1/application?id=#{@modelAppId}&subscription-key=#{@modelSubscriptionKey}&q="
dialog = new builder.LuisDialog(modelUrl)
module.exports = dialog
getOctobluUUID = (session, args, next) =>
  #prompt the user for their octoblu UUID
getOctobluToken = (session, args, next) =>
  #prompts the user for their Octoblu Token
authenticateWithMeshblu = (session, args, next) =>
  #Takes their Meshblu UUID and Token and logs in to octoblu, otherwise tell them to try again

dialog.on 'Help', builder.DialogAction.send(prompts.helpMessage)
dialog.on 'SetCredentials', [getOctobluUUID, getOctobluToken, authenticateWithMeshblu]
dialog.on 'MyDevices', [(session, args, next) =>]

dialog.on 'None', (session) =>



# dialog.on 'ListDeviceOptions', (session, args, next)
  #ask for their UUID
  #ask for their token
  #connect to meshblu and get their devices
  #show them to the user
# class OctoBotDialog extends builder.LuisDialog
#   constructor: ({@modelAppId, @modelSubscriptionKey}) ->
#
#     super(modelUrl)

# module.exports = OctoBotDialog
# var builder = require('../../../');
# var prompts = require('../prompts');
#
# /** Return a LuisDialog that points at our model and then add intent handlers. */
# var model = process.env.model || 'https://api.projectoxford.ai/luis/v1/application?id=597f02c4-0aac-47e2-a64c-790c54f43e98&subscription-key=6d0966209c6e4f6b835ce34492f3e6d9&q=';
# var dialog = new builder.LuisDialog(model);
# module.exports = dialog;
#
# /** Answer users help requests. We can use a DialogAction to send a static message. */
# dialog.on('Help', builder.DialogAction.send(prompts.helpMessage));
#
# /** Prompts a user for the title of the task and saves it.  */
# dialog.on('SaveTask', [
#     function (session, args, next) {
#         // See if got the tasks title from our LUIS model.
#         var title = builder.EntityRecognizer.findEntity(args.entities, 'TaskTitle');
#         if (!title) {
#             // Prompt user to enter title.
#             builder.Prompts.text(session, prompts.saveTaskMissing);
#         } else {
#             // Pass title to next step.
#             next({ response: title.entity });
#         }
#     },
#     function (session, results) {
#         // Save the task
#         if (results.response) {
#             if (!session.userData.tasks) {
#                 session.userData.tasks = [results.response];
#             } else {
#                 session.userData.tasks.push(results.response);
#             }
#             session.send(prompts.saveTaskCreated, { task: results.response });
#         } else {
#             session.send(prompts.canceled);
#         }
#     }
# ]);
#
# /** Prompts the user for the task to delete and then removes it. */
# dialog.on('FinishTask', [
#     function (session, args, next) {
#         // Do we have any tasks?
#         if (session.userData.tasks && session.userData.tasks.length > 0) {
#             // See if got the tasks title from our LUIS model.
#             var topTask;
#             var title = builder.EntityRecognizer.findEntity(args.entities, 'TaskTitle');
#             if (title) {
#                 // Find it in our list of tasks
#                 topTask = builder.EntityRecognizer.findBestMatch(session.userData.tasks, title.entity);
#             }
#
#             // Prompt user if task missing or not found
#             if (!topTask) {
#                 builder.Prompts.choice(session, prompts.finishTaskMissing, session.userData.tasks);
#             } else {
#                 next({ response: topTask });
#             }
#         } else {
#             session.send(prompts.listNoTasks);
#         }
#     },
#     function (session, results) {
#         if (results && results.response) {
#             session.userData.tasks.splice(results.response.index, 1);
#             session.send(prompts.finishTaskDone, { task: results.response.entity });
#         } else {
#             session.send(prompts.canceled);
#         }
#     }
# ]);
#
# /** Shows the user a list of tasks. */
# dialog.on('ListTasks', function (session) {
#     if (session.userData.tasks && session.userData.tasks.length > 0) {
#         var list = '';
#         session.userData.tasks.forEach(function (value, index) {
#             list += session.gettext(prompts.listTaskItem, { index: index + 1, task: value });
#         });
#         session.send(prompts.listTaskList, list);
#     }
#     else {
#         session.send(prompts.listNoTasks);
#     }
# });