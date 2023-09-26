var FindFlag="N";
var mainView;
var panel;
var RecordID='';
var PAPMIID='';
var PlayName='';
var PlanID="";
var adm="";

//document.write('<OBJECT ID="record" CLASSID="CLSID:B337FA03-112B-4991-A352-788551B37F5F" CODEBASE="../addins/client/record.CAB#version=1,0,0,0"> </OBJECT>')

function CreateMainPanel()
{
	
	var panelTitle="";
	panel=new Ext.Panel({
		//title:panelTitle,
		region: 'center',
		id:'panel',
		autoScroll:true,
		//layout:'form',
		//frame:true,
		viewConfig : {
			forceFit : true
		}
			// ,items:buttonPanel
		
	})
	//panel.add(buttonPanel);
	var Title=cspRunServerMethod(getTitle,RecordID,PlanID);
	if (Title=="") return false;
	var TitleArr=Title.split("^");
	var l=TitleArr.length;
	for (var i=0; i<l; i++) {
		var TitleInfo=TitleArr[i];
		var InfoArr=TitleInfo.split("&");
		var TitleID=InfoArr[0];
		var TitleCode=InfoArr[1];
		var TitleDesc=InfoArr[2];
		var Detail=cspRunServerMethod(getDetail,TitleID,RecordID)
		if (Detail=="") continue;
		var DetailArr=Detail.split("^");
		var j=DetailArr.length;
		var TitlePanel=new Ext.form.FieldSet({
			title:"<h1><BIG><BIG>"+TitleDesc+"</BIG></BIG>",
			frame:true,
			autoHeight: true,
			layout:'column',
			//layout:'table',
			collapsed:false,
			collapsible:true,
			collapseFirst:true,
			id:TitleID
		});
		//var items=[];
		for (var k=0; k<j; k++) {
			var DetailInfo=DetailArr[k];
			if (DetailInfo=="") continue;
			var DInfoArr=DetailInfo.split("&");
			var DetialID=DInfoArr[0];
			var DetailDesc=DInfoArr[2];
			var DetailType=DInfoArr[3];
			var DetailRequired=DInfoArr[6];
			var DetailUnit=DInfoArr[4];
			var DetailExplain=DInfoArr[5];
			var ElementNum=DInfoArr[8];
			var value=DInfoArr[7];
			if (ElementNum==0) {
				var width=.5
			} else {
				var width=1/ElementNum
			}
			var Field,RequiredBoolean=true;
			if (DetailRequired=="Y") RequiredBoolean=false;
			var DetailFieldSets=new Ext.form.FieldSet({
				title:"<BIG>"+DetailDesc+"</BIG>",
				layout:'column',
				id:"FS"+DetialID,
				columnWidth:1,
				border:false,
				frame:true,
				autoHeight:true,
				//collapsed:false,
				//collapsible:true,
				collapseFirst:true
			});
			//var item;
			if (DetailType=='T') {
				Field=new Ext.form.TextField({
					allowBlank:RequiredBoolean,
					emptyText:'请输入内容...',
					fieldLabel :DetailDesc,
					id:DetialID,
					//vtypeText:'请输入',
					value:value
				});
				var FieldPanel=new Ext.Panel({
					layout:'form',
					items:Field,
					id:"P"+DetialID,
					columnWidth: .5
				})
				TitlePanel.add(FieldPanel);
			} else if (DetailType=='N'){
				Field=new Ext.form.NumberField({
					allowBlank:RequiredBoolean,
					emptyText:'请输入数值...',
					fieldLabel :DetailDesc,
					id:DetialID,
					value:value
				});
				var FieldPanel=new Ext.Panel({
					layout:'form',
					items:Field,
					id:"P"+DetialID,
					columnWidth: .5
				})
				TitlePanel.add(FieldPanel);	
			}
			else if (DetailType=='D'){
				var Select=cspRunServerMethod(getSelect,DetialID,RecordID);
				SelectArr=Select.split("^");
				var m=SelectArr.length;
				for (var n=0; n<m; n++) {
					SelectInfo=SelectArr[n];
					if (SelectInfo=="") continue;
					SelectInfoArr=SelectInfo.split("&");
					SelectID=SelectInfoArr[0];
					SelectDesc=SelectInfoArr[1];
					SelectFlag=SelectInfoArr[2];
					if (SelectFlag=='Y') {
						SelectFlag=true
					} else {
						SelectFlag=false
					}
					Field=new Ext.form.Checkbox({
						id:SelectID,
						boxLabel:SelectDesc,
						checked:SelectFlag,
						hideLabel:true
						//,fieldLabel :SelectDesc
						//,labelSeparator:''
						
					});
					var FieldPanel=new Ext.Panel({
						layout:'form',
						items:Field,
						id:"P"+SelectID,
						autoHeight:true,
						columnWidth: width,
						style :' padding:0px 0px  0px  10px;'
					})
					DetailFieldSets.add(FieldPanel);
				};
				DetailFieldSets.doLayout(true);
				panel.doLayout(true);
				TitlePanel.add(DetailFieldSets);
			}
			else{
				var Select=cspRunServerMethod(getSelect,DetialID,RecordID);
				SelectArr=Select.split("^");
				var m=SelectArr.length;
				for (var n=0; n<m; n++) {
					SelectInfo=SelectArr[n];
					if (SelectInfo=="") continue;
					SelectInfoArr=SelectInfo.split("&");
					SelectID=SelectInfoArr[0];
					SelectDesc=SelectInfoArr[1];
					SelectFlag=SelectInfoArr[2];
					if (SelectFlag=='Y') {
						SelectFlag=true
					} else {
						SelectFlag=false
					}
					Field=new Ext.form.Radio({
						id:SelectID,
						name:DetialID,
						boxLabel:SelectDesc,
						checked:SelectFlag,
						hideLabel:true
						//,fieldLabel :SelectDesc
						//,labelSeparator:''
						
					});
					var FieldPanel=new Ext.Panel({
						layout:'form',
						items:Field,
						id:"P"+SelectID,
						autoHeight:true,
						columnWidth: width,
						style :' padding:0px 0px  0px  10px;'
					})
					DetailFieldSets.add(FieldPanel);
				};
				DetailFieldSets.doLayout(true);
				panel.doLayout(true);
				TitlePanel.add(DetailFieldSets);
			}
		};
		panel.add(TitlePanel);
	};
	panel.doLayout(true);
	var MainPanel=new Ext.Panel({
			title:panelTitle,
			defaults:{border:false},
			items:[panel],
			region:'center',
			layout:'border',
			frame:true,
			bodyBorder:false
	});
	panel=MainPanel;
}

function save_Click()
{
	/*
	var pp=panel.items.item(0).getId();
	//var item=pp.item(1);
	//var id=item.getId();
	*/
	var Template=""
	var saveInfo='';
	var mainInfo='';
	//var planID="";
	//var papmi="";
	var user=session['LOGON.USERID'];
	var demo="";
	
	var mainInfo=RecordID+"^"+PlanID+"^"+adm+"^"+PAPMIID+"^"+user+"^"+demo;
	
	var pp=panel.findByType('textfield');
	var j=pp.length;
	for (var i=0; i<j; i++) {
        
        if (!pp[i].isValid()) {
            Ext.MessageBox.show({
                title: '提示',
                msg: pp[i].fieldLabel + '不能为空',
                buttons: Ext.Msg.OK,
                fn: function(){
                    pp[i].focus();
                }
            });
            return false;
        }
		var id=pp[i].getId();
		var value=pp[i].getValue();
		//if (value!='') {
		if (saveInfo==""){
			saveInfo=id+"^"+value+"^"+Template;
		}
		else{
			saveInfo=saveInfo+"&"+id+"^"+value+"^"+Template;
		}
		//} 
	};
	var pp=panel.findByType('numberfield');
	var j=pp.length;
	for (var i=0; i<j; i++) {
		if (!pp[i].isValid()) {
            Ext.MessageBox.show({
                title: '提示',
                msg: pp[i].fieldLabel + '不能为空',
                buttons: Ext.Msg.OK,
                fn: function(){
                    pp[i].focus();
                }
            });
            return false;
        }
		var id=pp[i].getId();
		var value=pp[i].getValue();
		//if (value!='') {
		if (saveInfo==""){
			saveInfo=id+"^"+value+"^"+Template;
		}
		else{
			saveInfo=saveInfo+"&"+id+"^"+value+"^"+Template;
		}
		//} 
	};
	var pp=panel.findByType('checkbox');
	var j=pp.length;
	for (var i=0; i<j; i++) {
		
		var id=pp[i].getId();
		var value=pp[i].getValue();
		var string="";
		if (value) string=pp[i].boxLabel;
		//if (value) {
		if (saveInfo==""){
			saveInfo=id+"^"+string+"^"+Template;
		}
		else{
			saveInfo=saveInfo+"&"+id+"^"+string+"^"+Template;
		}
		//} 
	};
	saveInfo=mainInfo+"$"+saveInfo
	var result=cspRunServerMethod(saveClass,saveInfo);
	if (result>0){
		RecordID=result;
		Ext.MessageBox.alert("恭喜","保存成功");
	}
	else{
		Ext.MessageBox.alert("很遗憾","保存失败，请和管理员联系");
	}
}
function clear_Click()
{
	mainView.remove(panel)
	LoadPage();
}
function return_Click()
{
	RecordID='';
	PAPMIID='';
	mainView.remove(panel)
	LoadPage();
	
}
function record_Click(e)
{
	var RecordObj=new ActiveXObject("录音机.record");
	if (FindFlag == "Y") {
		if (PlayName=="")
		{
			Ext.MessageBox.alert('提示','本调查没有录音');
			return false;
		}
		RecordObj.CRMClose();
		RecordObj.PlayName=PlayName;
		RecordObj.CRMPlay();
		return false;
	}
    var RTimeLabel=new Ext.form.Label({
		html: '<p><h1><br><FONT SIZE =6 color=red>已录音时间0秒</FONT></h1></p>'
	});
	var RecordWin = new Ext.Window({
        title: '调查录音',
        layout: 'form',
        width: 400,
        height: 300,
        items: [{
            xtype: 'label',
            html: '<p> <FONT SIZE =6>正在录音，请讲话...</FONT></p>'
        }, RTimeLabel],
        buttons: [{
            text: '保存',
            handler: Save_Record
        }]
    });
	RecordWin.on('show',Win_Show);
	RecordWin.on('close',Win_Close);
	RecordWin.show();
	var RTime=0;
	var task = {
	    run: function(){
			RTime=RTime+1;
			RTimeLabel.destroy();
			RTimeLabel=new Ext.form.Label({
				style:' padding:300px 0px 50px  0px;',
				html: '<p><h1><br><FONT SIZE =6 color=red>已录音时间'+RTime+'秒</FONT></h1></p>'
			});
			RecordWin.add(RTimeLabel);
			RecordWin.doLayout(true);
	    },
	    interval: 1000 //1 second
	}
	Ext.TaskMgr.start(task);
	function Save_Record()
	{
		var mainInfo='';
		var planID="";
		var adm="";
		//var papmi="";
		var user=session['LOGON.USERID'];
		var demo="";
		var mainInfo=RecordID+"^"+planID+"^"+adm+"^"+PAPMIID+"^"+user+"^"+demo;
		var resultStr=cspRunServerMethod(getRecord,mainInfo);
		var resultArr=resultStr.split("^");
		var resultFlag=resultArr[0];
		if (resultFlag > 0) {
			RecordID = resultFlag
		}else{
			Ext.MessageBox.alert('很遗憾',resultArr[1]);
			RecordWin.close()
			return false;
		}
		Ext.TaskMgr.stopAll();
		RecordObj.DirStr=resultArr[1];
		RecordObj.CreateDir();
		RecordObj.SaveStr=resultArr[1]+RecordID+'.wav';
		RecordObj.CRMSave();
		RecordWin.close();
	}
	function Win_Show(Win)
	{
		RecordObj.CRMRecord();
	}
	function Win_Close(Win)
	{
		Ext.TaskMgr.stopAll();
		RecordObj.CRMClose();
		RecordObj=null;
	}
}
function CreateMainWindow()
{
	panel=new Ext.Window({
		title:'患者满意度调查',
		region:'center',
		layout:'form',
		items:[{xtype:'textfield',fieldLabel:'就诊卡号',emptyText:'请输入就诊卡号...',enableKeyEvents: true},{xtype:'textfield',disabled:true,fieldLabel:'姓名'},{xtype:'textfield',disabled:true,fieldLabel:'证件号码'}],
		buttons:[{
			id:'DCButton',
			text:'进入调查',
			handler:DC_Click
		}],
		width:250,
		height:150,
		closable:false
	})
    panel.items.item(0).on('change', RegNo_Change);
	panel.items.item(0).on('keydown', RegNo_KeyDown);
	function RegNo_Change(obj,newValue,oldValue)
	{
		if (newValue==''){
			PAPMIID = '';
			return false;
		}
		var RegNo=RegNoMask(newValue);
		var patientInfo=cspRunServerMethod(getPatientInfo,RegNo);
		var patienArr=patientInfo.split("^");
		PAPMIID=patienArr[0];
		if (PAPMIID=='')
		{
			Ext.Msg.alert("提醒","请输入正确的就诊卡号");
			return false;
		}
		obj.setValue(patienArr[1]);
		panel.items.item(1).setValue(patienArr[2]);
		panel.items.item(2).setValue(patienArr[3]);
		adm=patienArr[4];
		Ext.Msg.alert("提醒","请确认信息后点击'进入调查'按钮");
	}
	function RegNo_KeyDown(obj,e)
	{
		//e.getKey()
		if (e.getKey()==e.ENTER)
		{
			RegNo_Change(obj,obj.getValue(),'');
		}
	}
	function DC_Click()
	{
		if (PAPMIID=='')
		{
			Ext.Msg.alert("提醒","请输入正确的就诊卡号");
			return false;
		}
		panel.destroy();
        CreateMainPanel();

		View();
	}
}
function RegNoMask(RegNo)
{
	var length=8;
	var ZeroStr='0000000000000000000'.substr(1,length);
	RegNo=ZeroStr.substr(1,length-RegNo.length)+RegNo;
	return RegNo;
}
