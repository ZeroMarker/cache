//PMP.UserTel.js   联系方式
///2015-02-02  zzp
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    var name=session['LOGON.USERNAME']
    Ext.QuickTips.init();
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    ChartInfoAddFun();
    function ChartInfoAddFun() {
	   var Addwindow=new Ext.Window({
			  title:"维护联系方式",
			  layout:"form",
			  width:550,
		      height:210,
		      frame:true, 
		      plain:true,
		      minimizable:true,
		    //maximizable:true,
		    closable:"true",
		    buttonAlign:"center",
		    bodyStyle:"padding:7px",
		    //defaults:{xtype:"textfield",width:180},
		    frame:true,     //面板属性  底色为浅色
		    labelWidth:70,  //标题宽度
		    tbar:[{pressed:true,
		           text:"<img SRC='../scripts/Pmp/Image/save.gif'>保存",tooltip: "确认联系方式",
		           handler:function(){
		                  var AddTel=Ext.getDom("AddTel").value;
		                  AddUserTel(AddTel,userId);
		                   }}],
		    listeners:{
				"render":function(Addwindow){
				      Addwindow.add(new Ext.form.TextField({
								id:"AddTel",
								width : 200,
								regex:/^\d+(\.\d{1,2})?$/,
                                regexText: '请输入正确的数据类型',
								fieldLabel:"联系方式："
								})),
				     Addwindow.add(new Ext.form.TextField({
								id:"AddName",
								width : 200,
								fieldLabel:"姓名："
								}))}}
								}).show();    
	    }
	    Ext.getCmp("AddName").setValue(name); 
})
function AddUserTel(AddTel,userId){
	var url = "PMP.Common.csp?actiontype=AddTel&AddTel="+AddTel+"&userId="+userId;
	alert(url);
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '数据存储中..',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.alert("success", "数据更新成功!");
									//clearData();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Ext.Msg.alert("error", "数据更新失败!");
									}
								}
							},
							scope : this
						});
	}