/*
* 自定义表单家在页面 form.js
* by wuqk 2013-01-15
* config构成 {
* 	caption   ： 窗口title
* 	height    ： 窗口height
* 	width     ： 窗口width
* 	keyId     ： 读取实例数据Id
*   formCode  ： 表单代码
* 	formVerId ： 表单布局版本Id
*   design    :  是否设计态(design=1),设计态仅在传 formVerId 时有效
*   PatientID :  业务参数
*   EpisodeID :  业务参数
*   GoalUserID:  业务参数
* }
*/

var showForm = function(config){
	//debugger;
	//VerID,caption,design,keyId
	//alert(VerID);
	//var sUrl = fcpubdata.cspPath + "dhcmed.crf.directrun.csp?formid="+curFormId;
	var obj = new Object();
	//alert("ss");
	obj.buttons = [];
	
	obj.formVerId = (config.formVerId==undefined? "" : config.formVerId); //ExtTool.GetParam(window,"formVerId");  //表单版本Id
	obj.formId = (config.formId==undefined? "" : config.formId); //ExtTool.GetParam(window,"formId");        //表单Id
	obj.keyId = (config.keyId==undefined? "" : config.keyId); //ExtTool.GetParam(window,"keyId");          //实例数据Id
	obj.formCode = (config.formCode==undefined? "" : config.formCode); //ExtTool.GetParam(window,"formCode");    //表单代码
	obj.design = (config.design==undefined? "" : config.design); //ExtTool.GetParam(window,"design");        //设计态标记
	obj.locFlag=(config.locFlag==undefined? "" : config.locFlag);
	//业务参数	
	obj.PatientID = (config.PatientID==undefined? "" : config.PatientID); 
	obj.EpisodeID = (config.EpisodeID==undefined? "" : config.EpisodeID); 
	obj.GoalUserID = (config.GoalUserID==undefined? "" : config.GoalUserID);    
	//obj.PatientID = ExtTool.GetParam(window,"PatientID");
	//obj.EpisodeID = ExtTool.GetParam(window,"EpisodeID");
	//obj.GoalUserID = ExtTool.GetParam(window,"GoalUserID");
		
	obj.FormShow = ExtTool.StaticServerObject("DHCMed.CR.BO.FormShow");
	
	obj.CheckVersion = obj.FormShow.CheckFormInfo(obj.formCode,
		obj.formId,
		obj.keyId,
		obj.formVerId,
		obj.design,
		obj.PatientID,
		obj.EpisodeID,
		obj.GoalUserID);

	if (parseInt(obj.CheckVersion.split("^")[0])<0) {
		ExtTool.alert("Error",obj.CheckVersion,Ext.MessageBox.ERROR);
		return;
	}
	
	
	obj.formVerId = obj.CheckVersion.split("^")[0];
	
	obj.parameters = location.href.split("?")[1];  // "1=1&menuId=725"
	
	obj.link = "dhcmed.crf.directrun.csp?";  // + obj.parameters ;
	obj.link += "keyId=" + obj.keyId;
	obj.link += "&formCode=" + obj.formCode ;
	obj.link += "&formVerId=" + obj.formVerId ;
	obj.link += "&design=" + obj.design;
	obj.link += "&PatientID=" + obj.PatientID ;
	obj.link += "&EpisodeID=" + obj.EpisodeID ;
	obj.link += "&GoalUserID=" + obj.GoalUserID;
	
	//Add By LiYang 2013-12-28 将外面传入的参数传给【dhcmed.crf.directrun.csp】
	var arryParam = obj.parameters.split("&");
	var strTemplate = "keyId^formCode^formVerId^design^PatientID^EpisodeID^GoalUserID";
	for(var i = 0; i < arryParam.length ; i ++)
	{
		if(arryParam[i] == "")
			continue;
		var arryFields = arryParam[i].split('=');
		if(strTemplate.indexOf(arryFields[0]) == -1)
			obj.link += "&" + arryParam[i];
	}
	
	var ret = obj.FormShow.GetStatusByFormId(obj.formVerId.split("||")[0]);
	var arrStatus = Ext.decode(ret);
	var arrForms = new Object();
	for (var i=0; i<arrStatus.length; i++) {
		var iStatus = arrStatus[i];
		arrForms[iStatus.StatusCode] = iStatus.StatusName+"^"+iStatus.IsSubmitData+"^"+iStatus.IsCheckData;		
		//arrForms[iStatus.Code] =  iStatus.Description;
	}

	
	obj.btnPrint = new Ext.Toolbar.Button({ 
		id : 'btnPrint'
		,text : '打印'
		,handler : function(t){obj.btnPrint_click();}
	});
	
	obj.btnPreview = new Ext.Toolbar.Button({ 
		id : 'btnPreview'
		,text : '预览'
		,handler : function(t){obj.btnPreview_click();}
	});
	
	obj.btnCancle = new Ext.Toolbar.Button({ 
		id : 'btnCancle'
		,text : '关闭'
		,handler : function(){obj.btnCancle_click();}
	});
		
	//modify by mxp 2013-11-22
	obj.SetButtonStatus = function()
	{
		var statusList=ExtTool.StaticServerObject("DHCMed.CR.PO.StatusList");
		
		for(var k in obj.buttons)
		{
			var objBtn = obj.buttons[k];
			if(typeof objBtn != 'object')
				continue;
			var statusCode=objBtn.id.split("btn_")[1]
			//var txtCaption = objBtn.getText();
			switch(statusCode)
			{
				case "Print": //"打印":
					break;
				case "02": //"审核":  //只有查询界面才有可能有【AllowAudit】允许审核参数
				case "04": //退回":
					if(obj.locFlag=="1") //modify by mxp 2013-11-13
					//if(tDHCMedMenuOper['AllowAudit'] == 1)
						objBtn.show();
					else
						objBtn.hide();
					break;
				//case "01": //"上报":  //查询界面不允许上报，只能审核(可根据实际情况做修改)
				case "00": //草稿":
					if(obj.locFlag=="1") 
						objBtn.hide();
					else
						objBtn.show();	
				default:
					break;
			}
		var isThere=statusList.CheckStatus(obj.keyId,statusCode)			
		if(!Ext.decode(isThere))
				objBtn.enable();
		else
				objBtn.disable();
		if(obj.design) // 2013-11-13 运行设计状态的表单，屏蔽操作权限
				objBtn.disable();
		}
	}
	
	
	for (var k in arrForms){
		if (typeof arrForms[k]!="undefined") {
			//var isThere=statusList.CheckStatus(obj.keyId,k);
			var btnCaption = arrForms[k].split("^")[0]
			if (obj.buttons.length > 0){obj.buttons.push('-');}
			//if ((btnCaption!='打印')&&(btnCaption!='审核')) { //Modified By LiYang 2013-10-29 控制审核状态的显示
				
				
				//if(isThere){
				//			Ext.getCmp("btn_"+k).setDisabled(true);
				//		}
				obj.buttons.push(new Ext.Toolbar.Button({
					id : "btn_"+k,
					text : 	btnCaption,
					//disabled	:	Ext.decode(isThere),
					handler : function(t){
						//var falg=obj.btn_click(t.id.split("btn_")[1],arrForms[k]);
						var DataSrv = ExtTool.StaticServerObject("DHCMed.CR.BO.DataService");
						var statueCode=t.id.split("btn_")[1];
						var isSubmit = arrForms[statueCode].split("^")[1];						
						
						var UserID = session['LOGON.USERID'];
						if(statueCode == "04")
						{
							InitBackReason();
						}
						else{
							if((isSubmit == "1")||(statueCode == "00")||(statueCode == "01")){
								var isCheck=arrForms[statueCode].split("^")[2];
								obj.btn_click(statueCode,isCheck);
							}
							else{
								var retValue=DataSrv.ChangeDataStatus(statueCode,obj.keyId,UserID+"^");
								if (retValue>0){
									Ext.Msg.alert("提示",arrForms[statueCode].split("^")[0]+"成功!");
								}else{
									Ext.Msg.alert("提示",arrForms[statueCode].split("^")[0]+"失败!错误代码:"+retValue);						
								}
							}
						}
						obj.SetButtonStatus();
					}
				}));
		}
		
	}
	obj.SetButtonStatus();	
	
	obj.buttons.push('-');
	
	obj.buttons.push(obj.btnPreview);
	obj.buttons.push(obj.btnPrint);
	if(obj.design) obj.buttons.push(obj.btnCancle);

	/*
	var url = "dhcmed.crf.formshow.csp?";  //design="+design+"&PatientID=1&keyId="+keyId+"&formVerId="+VerID;
	url += "keyId=" + (config.keyId==undefined? "" : config.keyId) ;
	url += "&formCode=" + (config.formCode==undefined? "" : config.formCode) ;
	url += "&formVerId=" + (config.formVerId==undefined? "" : config.formVerId) ;
	url += "&design=" + (config.design==undefined? "" : config.design) ;
	url += "&" + (config.params==undefined? "" : config.params) ;
	
	*/
	obj.loading = null;
	obj.win = new Ext.Window({
				//id : 'xxxxxxxx',
				title : (config.caption==undefined ? "" : config.caption), 
				width : (config.width==undefined ? document.body.clientWidth : config.width),  //800,
				height : (config.height==undefined ? document.body.clientHeight : config.height), // document.body.clientHeight,  //600,
				isTopContainer : true,
				modal : true,
				resizable : false,
				closable:false,      //Modified By LiYang 2014-05-14
				/* update by zf 2013-12-19
				tools : [{
					id : 'down',
					qtip : '状态列表',
					hidden : (config.keyId==undefined? true : false),
					handler: function(e, target, panel){
			           (new Ext.Window({
			           		title : 'Status list',
			           		width : 200,
			           		height : 100,
							modal : true,			           		
			           		html : config.keyId
			           	})).show();
			        }
				}],*/
				html : '<iframe id="dhcmed_crf_form" src= '+ obj.link + ' width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>',
				bbar:{buttonAlign: 'right',items: obj.buttons } 
			});

	obj.win.show();
	
	obj.reload = function(){
		var ifrmCRFForm = document.getElementById("dhcmed_crf_form");
		if (obj.link.indexOf("keyId") < 0 ){
				var links = obj.link.split("?")[0] + "?keyId=" + obj.keyId + "&" + obj.link.split("?")[1];
				obj.link = links;
		}
		ifrmCRFForm.src = obj.link;
	};
	
	obj.btnPrint_click = function()
	{
		if (obj.btnPreview.getText() == '编辑') {
			document.getElementById('dhcmed_crf_form').contentWindow.location.href = obj.link + '&printed=2';
		} else {
			obj.btnPreview.setText('编辑');
			document.getElementById('dhcmed_crf_form').contentWindow.location.href = obj.link + '&printed=3';
		}
		//window.open(obj.link + "&printed=1","newwindow","height=450,width=700,top=0,left=0,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no");
	};
	
	obj.btnPreview_click = function()
	{
		if (obj.btnPreview.getText() == '预览') {
			obj.btnPreview.setText('编辑');
			document.getElementById('dhcmed_crf_form').contentWindow.location.href = obj.link + '&printed=1';
		} else {
			obj.btnPreview.setText('预览');
			document.getElementById('dhcmed_crf_form').contentWindow.location.href = obj.link;
		}
	};
	
	obj.btnCancle_click = function()
	{
		obj.win.close();
		//if(obj.keyId) document.getElementById('dhcmed_crf_form').contentWindow.close();
	};
	
	function InitBackReason()
{
	mainWindow = new Ext.Window({
		id : 'mainWindow'
		,height : 150
		,buttonAlign : 'center'
		,width : 400
		,title : '请录入退回原因'
		,layout : 'fit'
		,modal:true
		,items : [
			new Ext.form.TextArea
			({
				id : 'resumeText'
				,height : 60
				,width:500
				,anchor : '95%'
			})
		]
		,buttons : [
			new Ext.Button
			({
				id : 'saveBtn'
				,iconCls : 'icon-save'
				,anchor : '95%'
				,text : '确定'
				,handler: function (){
					if (!(rejText = document.getElementById('resumeText').value)){
						ExtTool.alert("提示","退回原因不能为空");
						return;
					}
					var DataSrv = ExtTool.StaticServerObject("DHCMed.CR.BO.DataService");
					var retValue=DataSrv.ChangeDataStatus("04",obj.keyId,session['LOGON.USERID']+"^"+rejText);
					mainWindow.close();
					if (retValue>0){
						Ext.Msg.alert("提示","退回成功!");
						obj.SetButtonStatus();
					}else{
						Ext.Msg.alert("提示","退回失败!错误代码:"+retValue);						
					}
				}
			})
			,({
				id : 'cancleBtn'
				,iconCls : 'icon-cancle'
				,anchor : '95%'
				,text : '取消'
				,handler: function (){
					mainWindow.close();
				}
			})
		]
	});
	mainWindow.show();
}	
	
	obj.btn_click = function(statusCode,isCheck)
	{
		var falg="";
		var ifrmCRFForm = document.getElementById("dhcmed_crf_form");
		if (typeof ifrmCRFForm.contentWindow.DjSave =="function"){	
			//debugger;
			falg=ifrmCRFForm.contentWindow.DjSave(statusCode,isCheck);
			obj.keyId=ifrmCRFForm.contentWindow.PrimaryKey;
			
			//if(window.returnValue != null)
			window.returnValue = obj.keyId;
			
			//update by zf 2013-12-25 处理keyId
			var re=eval('/(' + 'keyId' + '=)([^&]*)/gi');
			var olnk = obj.link;
			obj.link = olnk.replace(re,'keyId' + '=' + obj.keyId);
			
			document.getElementById('dhcmed_crf_form').contentWindow.location.href = obj.link;
			//obj.reload();	
		}
		//ifrmCRFForm.contentWindow.document.body.disabled = true;
		return falg;
		//return false;	
	};
}
