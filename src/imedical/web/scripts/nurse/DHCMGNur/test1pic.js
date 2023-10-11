/**
 * @author Qse
 */
var action = new Ext.Action({
    text: 'Do something',
    handler: function(){
        Ext.Msg.alert('Click', 'You did something.');
    },
    iconCls: 'do-something'
});
function a(){alert('some thing');}
var panel = new Ext.Panel({
	id:'hh',
    title: 'Actions',
    width:500,
    height:300,
    
    tbar: [
        // Add the action directly to a toolbar as a menu button
        action, {
            text: 'Action Menu',
            // Add the action to a menu as a text item
            menu: [action]
        }
    ],
    items: [
        // Add the action to the panel body as a standard button
        new Ext.Button(action)
    ],
    renderTo: Ext.getBody()
});

// Change the text for all components using the action
action.setText('Something else');
Ext.onReady(function(){
	Ext.QuickTips.init();
    Ext.get("hh").addListener("mouseout",a);

    }); 
