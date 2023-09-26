/**
* @author: wanghc
* @date: 2012/3/1
* 主页面
* scripts/dhcdoc/DHCDocMainView.js
*/
var patientTreePanel, patientInfoPanel,loadingwin,pbar, longPointBar = 0, timeoutHandlerId ; //, patientTreePanelWidth = 210;
var patientQueryBar, patientQueryNameBar, patientQueryMedicalBar,patientQueryCardNoBar,patientQueryCardType,StartDateBar,AdmDayBar,MarkList;
var Intval="";var CallSecond=5
/**
* @author wanghc
* @date 2012/5/18
* @param {String} str
* @return {HTMLString} html html片段
*/
var timeOut=""
var DateFormat=tkMakeServerCall("websys.Conversions", "DateFormat");
function reservedToHtml(str){
	var html = str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		if(v=="&lt;" || v=="&#60;") return "<";
		if(v=="&gt;" || v=="&#62;") return ">";
		if(v=="&quot;" || v=="&#34;") return "\"";
		if(v=="&apos;" || v=="&#39;") return "'";
		if(v=="&amp;" || v=="&#38;") return "&";
	});
	return html;
}
function hideLoadingWinFun(){
	var p = Ext.getCmp("DHCDocTabPanel").getActiveTab();
	if(p){	
		if(window.frames[p.frameName] && window.frames[p.frameName].document && window.frames[p.frameName].document.readyState == 'complete'){
			clearTimeout(timeoutHandlerId);
			pbar.reset();
			loadingwin.hide();			
			longPointBar = 0;
		}else{
			if (longPointBar==10){ 
				longPointBar = 0 
			}else{
				longPointBar += 2;
			}
			pbar.updateProgress(longPointBar/10, '加载中...', false);
			timeoutHandlerId = setTimeout(hideLoadingWinFun,200);			
		}
	}
}
function GetCurrentChartLink() {
	var obj=Ext.getCmp('DHCDocTabPanel');
	//alert(obj.getActiveTab().initialConfig.cls);
	return obj.getActiveTab().initialConfig.cls ;
}
var DHCDocMainView =  {
	requestCSP : "dhcdoc.request.csp",
	baseCLS: "web.DHCDocMainOut",
	barInfoMethod: "GetPatientBaseInfo",
	PatientID: "",
	EpisodeID: "",
	mradm: ""
};
var refreshBar = function (){
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value; //DHCDocMainView.PatientID;
		var adm = frm.EpisodeID.value; //DHCDocMainView.EpisodeID;
		var tmp;
		var tmp = {
		    papmi : frm.PatientID.value,
		    adm : frm.EpisodeID.value,
		    mradm : frm.mradm.value
		};
		
		invokeChartFun('门诊病历','xhrRefresh',tmp)   //2017-12-28
		if (adm > 0 ){
			getChartItemsInfo(papmi,adm,frm.mradm.value);
			patientInfoPanel.load({
				url:'websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.Banner.Out',
				params:{PatientID:papmi,EpisodeID:adm},
				callback:function(html,p2){
					html.dom.style.height = "36px";
					html.dom.innerHTML = "<div id='PageContent'>"+document.getElementById("dPAPerson_Banner_Out").innerHTML+"</div>"
					
					var obj = document.getElementById("BANNERAdmCharge");
					if(obj){
						if (obj.value<0) obj.style.color="red";
					}
					var sourceFlagObj  = document.getElementById("REAAdmSourceFlag");
					if  (sourceFlagObj && sourceFlagObj.value==1){
						var obj1 = document.getElementById("BANNERPAADMAdmReason")
						if (obj1){
							obj1.style.color = "blue";
						}
					}
					var formObj = document.getElementById("fPAPerson_Banner_Out");
					if (formObj){
						var formtables = formObj.getElementsByTagName("table");
						for (var i=0 ; i<formtables.length ; i++){
							formtables[i].style.height="20px"	
						}
						//不换行
						var tds = formObj.getElementsByTagName("TD");
						var len = tds.length;
						for(var i=0; i<len; i++){
							tds[i].setAttribute("noWrap","noWrap");
						}
					}
				},
				scripts:false,
				timeout:300
			});
			/*
			var info = tkMakeServerCall(DHCDocMainView.baseCLS, DHCDocMainView.barInfoMethod, papmi, adm);
			var obj = Ext.decode(info);
			var tbTextObj ;
			for (var i in obj){
				if (obj.hasOwnProperty(i)){
					tbTextObj = Ext.getCmp(i);
					if(tbTextObj&& i == "baseIconProfile"){
						tbTextObj.update(reservedToHtml(obj[i]));
					}else if(tbTextObj) {
						tbTextObj.setText(obj[i]);
					}
				}
			}*/
		}
	}
};
//调用panel页面iframe中的xhrRefresh方法
var xhrRefresh = function(forceRefresh){
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value; //DHCDocMainView.PatientID;
		var adm = frm.EpisodeID.value; //DHCDocMainView.EpisodeID;
		var mradm = frm.mradm.value; //DHCDocMainView.EpisodeID;
		if ((adm > 0) || (forceRefresh == true) ){
			var p = Ext.getCmp("DHCDocTabPanel").getActiveTab();	
			var frame = window.frames[p.frameName];		
			if ( frame && "function" === typeof frame.xhrRefresh ){
				frame.xhrRefresh({papmi: papmi, adm: adm, mradm: mradm, forceRefresh: (forceRefresh || false)});				
			}
		}else{
			//alert("请选择病人");
		}
	}
};
var rewriteUrl = function(url, obj){
	var reg,flag, indexFlag = false;
	var indexFlag = (url.indexOf("?")==-1);
	if(indexFlag){
		url += "?";	
	}
	for (var i in obj){	
		if(obj.hasOwnProperty(i)){
			flag = false; 	//包含与否
			if(!indexFlag){	//url不包含?就不走replace
				reg =  new RegExp(i+"=","g");
				url = url.replace(reg, function(m1){
					flag = true;
					return i+"="+obj[i];
				});
			}
			if(!flag){
				url  +=   "&" + i + "=" + obj[i];
			}
		}
	}
	return url;	
}
//重新load整个页面,并加载数据
var hrefRefresh = function (forceRefresh){
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value; //DHCDocMainView.PatientID;
		var adm = frm.EpisodeID.value; //DHCDocMainView.EpisodeID;
		var mradm = frm.mradm.value; //DHCDocMainView.EpisodeID;
		if (adm > 0){
			var tmp;
			var tmp = {
			    papmi : frm.PatientID.value,
			    adm : frm.EpisodeID.value,
			    mradm : frm.mradm.value
			};
			invokeChartFun('门诊病历','xhrRefresh',tmp)   //2017-12-28
			
			var p = Ext.getCmp("DHCDocTabPanel").getActiveTab();	
			var iframe = p.el.dom.getElementsByTagName("iframe")[0];
			var iframesrc = iframe.src;
			//alert("papmi"+papmi);
			var url = rewriteUrl(p.src,{PatientID:papmi, EpisodeID:adm, mradm: mradm, copyOeoris:'', copyTo:''});			
			//alert(url);
			//为了下医嘱能重定向到自已页面
			if (p.initialConfig) {
				p.initialConfig.cls = url;	
			}else{
				p.initialConfig = {};
				p.initialConfig.cls = url;	
			}			
			if((forceRefresh==true)||(iframesrc.slice(iframesrc.indexOf("?")) != url.slice(url.indexOf("?")))) {				
				if(pbar) {loadingwin.show();}				
				//pbar.wait({interval:200,text:'加载中...',increment:10});				
				iframe.src = url;				
				if(pbar) {setTimeout(hideLoadingWinFun,100);}
			}; 	//缓存刷新
		}else{
			//alert("请选择病人");
		}
	}	
}
var resetEprMenuForm = function(){
	var frm = dhcsys_getmenuform();
	if (frm) {
		frm.EpisodeID.value = "";
		frm.PatientID.value = "";
		frm.mradm.value = "";
		frm.AnaesthesiaID.value = "";
	}
}
var setEprMenuForm = function(adm,papmi,mradm){
	var frm = dhcsys_getmenuform();
	if (frm) {
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		frm.mradm.value = mradm; 				//DHCDocMainView.EpisodeID;
		frm.AnaesthesiaID.value = "";
	}
} 
function hideQueryBar (){
	patientQueryBar.hide();
	patientQueryNameBar.hide();
	patientQueryMedicalBar.hide();
	
	//if(PAADMType && PAADMType=="O") {
		patientQueryCardType.hide();
		patientQueryCardNoBar.hide();
		StartDateBar.hide();
		//AdmDayBar.hide();
	//}
	var width = patientTreePanel.getWidth();
	patientTreePanel.setWidth(width);
	Ext.getCmp('docmainviewport').syncSize();

}
function showQueryBar(){
	patientQueryBar.show();
	patientQueryNameBar.show();
	//patientQueryMedicalBar.show();
	
		patientQueryCardType.show();
		patientQueryCardNoBar.show();
		StartDateBar.show();
		AdmDayBar.show();
	var width = patientTreePanel.getWidth();
	patientTreePanel.setWidth(width);
	Ext.getCmp('docmainviewport').syncSize();
}
var isTimeFresh=0; //是否是定时刷新，定时刷新时不进行选中行
var findPatientTree = function(e){
	isTimeFresh=0;
	var patientNo = Ext.getCmp('patientNoTF').getValue();
	var ruleNo="", len = regLength,patLen;
	for(var i=0;i<len;i++){ruleNo += '0' ;}
	if(patientNo!=""){
		patLen = patientNo.length;
		if(len-patLen>=0){
			patientNo = ruleNo.slice(0,len-patLen)+patientNo;
		}else{
			patientNo = patientNo.slice(patLen-len);
		}
		Ext.getCmp('patientNoTF').setValue(patientNo);
	}
	
	var patientCardNo=Ext.getCmp('patientCardNoTF').getValue();
	if(patientCardNo!="") CardNoKeyDown();
	var patientNo = Ext.getCmp('patientNoTF').getValue();
	var store = patientTreePanel.store;
	store.baseParams.P2 = patientNo;
	store.baseParams.P3 = Ext.getCmp('patientNameTF').getValue();
	store.baseParams.P4 = Ext.getCmp('patientMedicalTF').getValue();
	store.baseParams.P5=PAADMType
	store.baseParams.P6 = Ext.getCmp('patientCardNoTF').getValue();
	//OutStartDate , OutEndDate , OutArrivedQue ,OutRegQue, OutConsultation ,OutAllPatient 

	var StartDate=Ext.getCmp('AdmStartDate').getRawValue();
	var AdmDay=Ext.getCmp('AdmDayLimit').getValue();
	if (AdmDay!=""){
		StartDate=tkMakeServerCall("web.DHCDocMainOut", "GetLimirDay", StartDate, AdmDay);
	}
	store.baseParams.P7 = StartDate ;
	//store.baseParams.P7 = Ext.getCmp('AdmStartDate').getRawValue();
	store.baseParams.P8 = Ext.getCmp('AdmEndDate').getRawValue();
	
	var ArrivedQue=document.getElementById("ArrivedQue").checked;
	var RegQue=document.getElementById("RegQue").checked;
	var Consultation=document.getElementById("Consultation").checked;
	var AllPatient=document.getElementById("AllPatient").checked;
	if(ArrivedQue){
		ArrivedQue="on"
	}else{
		ArrivedQue=""	
	}
	if(RegQue){
		RegQue="on"
	}else{
		RegQue=""	
	}
	if(Consultation){
		Consultation="on"
	}else{
		Consultation=""	
	}
	if(AllPatient){
		AllPatient="on"
	}else{
		AllPatient=""	
	}
	store.baseParams.P9 = ArrivedQue
	store.baseParams.P10 = RegQue
	store.baseParams.P11 = Consultation
	store.baseParams.P12 =AllPatient
	var AdmReqNo=Ext.getCmp('AdmReqNo').getValue();
	store.baseParams.P13 =AdmReqNo
	store.baseParams.P14 =Ext.getCmp("MarkList").getValue() //号别选择
	store.load();
	//setTimeout(SelectOnlyPat,100)
	window.clearTimeout(timeOut)
	if (RegQue=="on"){
	//if((PAADMType)&&(PAADMType=="O")){
		timeOut=window.setTimeout(findPatientTree1,120000);
	//}	
	}
}
var findPatientTree1=function(){
	isTimeFresh=1;
	//当定时刷新时不需要一些搜索条件
	Ext.getCmp('patientNoTF').setValue("");
	var store = patientTreePanel.store;
	store.baseParams.P2 = "";
	Ext.getCmp('patientNameTF').setValue("")
	Ext.getCmp('patientMedicalTF').setValue("")
	store.baseParams.P3 = "";
	store.baseParams.P4 ="";
	store.baseParams.P5=PAADMType
	Ext.getCmp('patientCardNoTF').setValue("")
	store.baseParams.P6 =""
	//OutStartDate , OutEndDate , OutArrivedQue ,OutRegQue, OutConsultation ,OutAllPatient 
	store.baseParams.P7 = Ext.getCmp('AdmStartDate').getValue();
	store.baseParams.P8 = Ext.getCmp('AdmEndDate').getValue();
	
	var ArrivedQue=document.getElementById("ArrivedQue").checked;
	var RegQue=document.getElementById("RegQue").checked;
	var Consultation=document.getElementById("Consultation").checked;
	var AllPatient=document.getElementById("AllPatient").checked;
	
	if(ArrivedQue){
		ArrivedQue="on"
	}else{
		ArrivedQue=""	
	}
	if(RegQue){
		RegQue="on"
	}else{
		RegQue=""	
	}
	if(Consultation){
		Consultation="on"
	}else{
		Consultation=""	
	}
	if(AllPatient){
		AllPatient="on"
	}else{
		AllPatient=""	
	}

	store.baseParams.P9 = ArrivedQue
	store.baseParams.P10 = RegQue
	store.baseParams.P11 = Consultation
	store.baseParams.P12 =AllPatient
	var AdmReqNo=Ext.getCmp('AdmReqNo').getValue();
	store.baseParams.P13 =AdmReqNo
	store.baseParams.P14 =Ext.getCmp("MarkList").getValue()

	//store.baseParams.P9 = ""
	//store.baseParams.P10 = ""
	//store.baseParams.P11 = ""
	//store.baseParams.P12 =""
	store.load();
	window.clearTimeout(timeOut)
	if (RegQue=="on"){
	//if((PAADMType)&&(PAADMType=="O")){
		timeOut=window.setTimeout(findPatientTree1,120000);
	//}	
	}	
}
var isVaildUseDHCOE = function(p){
	var tp = Ext.getCmp('DHCDocTabPanel');
	var DHCOEPage=0;
	var frm = dhcsys_getmenuform();
	if(orderTabIndex>-1){
		DHCOEPage = (tp.getComponent(orderTabIndex)==p) ? 1:0;
	}
	if(frm.EpisodeID.value == 0){
		alert("请选中病人!");	//开医嘱前必须选中病人
		return false;	
	}
	if ((DHCOEPage==1) && frm.EpisodeID.value == 0 ){				
		alert("请选中病人再开医嘱!");	//开医嘱前必须选中病人	oeorder.oplistcustom.csp
		return false;
	}else{
		if((DHCOEPage==1)&&document.getElementById("baseIsEstDisch").innerText=="1"){
			alert("病人已医疗结算不能下医嘱!");
			return false;
		}
	}
	return true;
}
var gridPanelClick =  function (r,forceRefresh){
	if(!CheckSelectPat()){
		return 
	}
	var pid = r.data['PatientID'];
	var eid = r.data['EpisodeID'];
	var mid = r.data['mradm'];	
	if((true===forceRefresh) || (DHCDocMainView.EpisodeID != eid)){
		DHCDocMainView.PatientID = pid;
		DHCDocMainView.EpisodeID = eid;
		DHCDocMainView.mradm = mid;
		setEprMenuForm(eid,pid,mid);
		refreshBar();
		var p = Ext.getCmp("DHCDocTabPanel").getActiveTab();
		isVaildUseDHCOE(p)
		if (p.allRefresh === true){						
			hrefRefresh(forceRefresh);
		}else{
			xhrRefresh(forceRefresh);
		}
	}
}

var initComp = function(){
	if(typeof IsUseProgressBar != "undefined" && !IsUseProgressBar ){
	}else{
		pbar = new Ext.ProgressBar({id:'loadingpbar', width:300});
		loadingwin = new Ext.Window({
			id:'loadingwin',closable:false, modal:true, layout:'fit', width:400, height:37,
			items: pbar
		});	
	}
	
	patientInfoPanel = new Ext.Panel({
		region: 'north',
		split: false,
		height: "30px",
		bodyStyle:{marginTop:'-1px',padding:0,paddingBottom:10,background:'#edf5ff'},
		//bodyCfg: {cls:'x-panel-header'},
		//bodyStyle:'padding:2 0 2 0',
		//bodyCfg: {cls:'x-panel-footer'},
		html: '<div style="height:30px;background-color:#edf5ff;"><table><TBODY><TR><TD noWrap><STRONG>选中的病人信息</STRONG> <LABEL id=BANNERRegistrationNo name="BANNERRegistrationNo"></LABEL></TD></TR></TBODY></table></div>'
		,listeners:{"afterrender": function(){
			setTimeout("refreshBar()",1)
		}}
	});
		
	patientQueryBar = new  Ext.Toolbar({
		hidden:true,
		items: ["登&nbsp记&nbsp号&nbsp:", new Ext.form.TwinTriggerField({
			width:130,id:'patientNoTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
			},
			onTrigger2Click: findPatientTree
		}),"&nbsp","-","&nbsp","未就诊:","<input id='RegQue' type='checkbox' checked='checked'/>"
		]
	});
	patientQueryNameBar = new  Ext.Toolbar({
		hidden:true,
		items: ["患者姓名:", new Ext.form.TwinTriggerField({
			width:130,id:'patientNameTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
			},
			onTrigger2Click: findPatientTree
		}),"&nbsp","-","&nbsp","全&nbsp&nbsp&nbsp部:","<input id='AllPatient' type='checkbox'/>"]
	});
	patientQueryMedicalBar = new  Ext.Toolbar({
		hidden:true,
		items: ["住院号:", new Ext.form.TwinTriggerField({
			width:130,id:'patientMedicalTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
			},
			onTrigger2Click: findPatientTree
		}),"&nbsp&nbsp","-","&nbsp&nbsp","会&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp诊:","<input id='Consultation' type='checkbox'/>" ]
	});
	patientQueryCardType=new Ext.Toolbar({
		hidden:true,
		items:['卡&nbsp类&nbsp型&nbsp:',new Ext.form.ComboBox({		
				typeAhead: true,
				fieldLabel: '卡类型',
				width: 130,
				name: "CardTypeDefine",
				id: "CardTypeDefine",
				triggerAction: 'all',
				lazyRender: true,		
				mode:'local',
				store: new Ext.data.ArrayStore({
					fields: ['typeRowid','typeDesc'],
					data: CardTypeJson	//"[0,'本人病人'],[1,'本科室病人'],[2,'本单元病人'],[3,'在院历史病人']"
				}),
				displayField: 'typeDesc',
				valueField:'typeRowid',
				value: DefaultCardType,
				editable:false,		
				allowBlank: false
		}),"&nbsp","-",'&nbsp', new Ext.Button({
				id:'ReadCard',
				text:'<font color=red><b>读卡</b></font>',
				iconCls:'icon-readcard-custom',
				handler:function(b,e){
					var myoptval=Ext.getCmp("CardTypeDefine").getValue();
					var myary=myoptval.split("^");
					var myCardTypeDR=myary[0];
					var CardInform=DHCACC_GetAccInfo(myCardTypeDR,myoptval)
					var myary=CardInform.split("^");
    				var rtn=myary[0];
					switch (rtn){
						case "-200": //卡无效
							alert("卡无效");
							//document.getElementById('PatientNo').value=""
							break;
						case "-1": //卡无效
							alert("卡无效");
							//document.getElementById('PatientNo').value=""
							break;
						default:
							Ext.getCmp("patientCardNoTF").setValue(myary[1])
							Ext.getCmp("patientNoTF").setValue(myary[5])
							findPatientTree();
							break;
					}	
				}	
		})
		]	
	});
	
	patientQueryCardNoBar = new  Ext.Toolbar({
		hidden:true,
		items: ["就诊卡号:", new Ext.form.TwinTriggerField({
			width:130,id:'patientCardNoTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
			},
			onTrigger2Click:findPatientTree
		}),'&nbsp',"-",'&nbsp',{
			text:'查询',
			iconCls:'icon-find-custom',
			handler:function(b,e){
				findPatientTree();
			}
		}]
	});
	
	StartDateBar=new Ext.Toolbar({
		hidden:true,
		items:[
			'开始日期:',{xtype:'datefield',id:'AdmStartDate',format:websys_DateFormat,validateOnBlur:false,value:new Date},
			'结束日期:',{xtype:'datefield',id:'AdmEndDate',format:websys_DateFormat,validateOnBlur:false,value:new Date}
		]
	});

	AdmDayBar = new  Ext.Toolbar({
		//hidden:true,
		items: ["查天数:", new Ext.form.TextField({
				width:50,
				id:'AdmDayLimit',
				enableKeyEvents:true,
				onTrigger1Click: function(e){
					this.setValue("");
				},
				onTrigger2Click: findPatientTree
			}), "挂号序号:", new Ext.form.TextField({
				width:50,
				id:'AdmReqNo',
				enableKeyEvents:true,
				onTrigger1Click: function(e){
					this.setValue("");
				},
				onTrigger2Click: findPatientTree
			}),"&nbsp","-","&nbsp","已就诊:","<input id='ArrivedQue' type='checkbox'/>"
			/*
			,'-',
			{text:"展开",iconCls:'icon-expand-custom',handler:function(b, e){
					if(b.text=="展开"){
						b.setText("收起");
						patientTreePanel.setWidth(1300);
						Ext.getCmp("docmainviewport").syncSize();
					}else{
						b.setText("展开");
						patientTreePanel.setWidth(patientTreePanelWidth);
						Ext.getCmp("docmainviewport").syncSize();
					}
				}
			}
			*/
		]
	});
	MarkList = new  Ext.Toolbar({
		//hidden:true,
		items: ["选号别:", new Ext.form.ComboBox({
			typeAhead: true,
				fieldLabel: '选号别',
				width: 150,
				height: 45,
				name: "MarkList",
				id: "MarkList",
				triggerAction: 'all',
				lazyRender: true,		
				mode:'local',
				onTrigger2Click: findPatientTree,
				store: new Ext.data.ArrayStore({
					fields: ['typeRowid','typeDesc'],
					data: DocMarkJson 
				}),
				displayField: 'typeDesc',
				valueField:'typeRowid',
				editable:false,		
				allowBlank: false,
				listeners: { 
					select: function(combo, record, index) {
						//保存到session中
						var SelMarkID=Ext.getCmp("MarkList").getValue();
						var SetSessionObj=document.getElementById('SetSessionDataMethod');
						if (SetSessionObj) {var encmeth=SetSessionObj.value} else {var encmeth=''};
						if (encmeth!=""){cspRunServerMethod(encmeth,"MarkSelectDr",SelMarkID)}
						
						findPatientTree()
					}
				}
			})
		]
	});
	
	patientTreePanel = new dhcc.icare.MixGridPanel({
		region: 'west',
		title:"患者列表",
		split: true,
		width:patientTreePanelWidth,
		collapsible: true,
		hiddenCM:['PatientID','EpisodeID','mradm','PAAdmReasonCode','FinancialDischargeFlag','MedicalDischargeFlag','PAAdmReasonCode','StatusCode','PriorityCode','Called','RegDocDr'],
		listClassName: 'web.DHCDocMainOut',
		listQueryName: 'FindCurrentAdmProxy',
		pageSize: 50,		
		tbar: [
			{text:"查找",iconCls:'icon-find-custom',handler:function(b,e){
					if(patientQueryBar.isVisible()) hideQueryBar();
					else showQueryBar();
				}
			},'-',{text:"呼叫",iconCls: 'icon-call-custom',handler:function(b,e){
					var ret=NewCallPatient();
					if(!ret) return 
					b.setText("<font color='#666666'>"+"正在呼叫"+5+"</font>")
					b.setDisabled(true)
					Intval=setInterval(function(){
						CallSecond=CallSecond-1
						if(CallSecond<0){
							clearInterval(Intval)
							Intval=""
							CallSecond=5
							b.setText("呼叫")
							b.setDisabled(false)
							return 
						}
						b.setText("<font color='#666666'>"+"正在呼叫"+CallSecond+"</font>")
						return 
					},1000)				
				}
			},"-",{text:"重复呼叫",iconCls:'icon-recall-custom',handler:function(b,e){
				ReCallPatient()	
			 	}
			
		},"-",{text:"过号",iconCls:'icon-skip-custom',handler:function(b,e){
				if(patientTreePanel.getSelectionModel().getCount()>0){
					var r = patientTreePanel.getSelectionModel().getSelected();
					var AdmDate=r.get("PAAdmDate")
					if(r.get("Called")==""){
						alert("没有呼叫的病人不能过号")
						return
					}
					if (CheckAdmDate(AdmDate)==false) {
						alert("请选择当日就诊病人")
						return false;
					}
					var PAPMIName=r.get("PAPMIName")
					if(PAPMIName.indexOf("</A>")>=0){
						PAPMIName=PAPMIName.split("</A>")[0].split(">")[1]	
					}
					if(PAPMIName.indexOf("&lt;/A&gt;")>=0){
						PAPMIName=PAPMIName.split("&lt;/A&gt;")[0].split("&gt;")[1]	
					}
					var Patient=r.get("PAPMINO")+" "+PAPMIName
					var Rtn=confirm(Patient+' '+"是否需要过号?");
						if (!Rtn){
						return false;
					}
					var EpisodeID=r.get("EpisodeID")
					var DoctorId= DocDr   //r.get("RegDocDr")
					var Stat=cspRunServerMethod(SetSkipStatus,EpisodeID,DoctorId);
					if (Stat!='1')	{
						alert("过号失败!");
						return false;
					}
					findPatientTree();
				}else{
						alert("请选择要过号的病人！")	
				}					
			}
			
		}/*,"-",{id:'ReturnNumber',text:"退号",iconCls:'icon-cancel-custom',handler:function(b,e){
				if(patientTreePanel.getSelectionModel().getCount()>0){
					var r = patientTreePanel.getSelectionModel().getSelected();
					var EpisodeID=r.get("EpisodeID") ;
					if(EpisodeID==""){
						alert("请选择病人") ;
						return 		
					}
					if(!confirm("是否继续退号?退号后病人就诊需重新挂号！！")) return
					var UserId=session["LOGON.USERID"]
					var LocRowid=session["LOGON.CTLOCID"]
					var GroupId=session['LOGON.GROUPID']
					var rtn=tkMakeServerCall("web.DHCDocOutPatientList","CancelOPRegist",EpisodeID,UserId,LocRowid,GroupId)
					var rtnArr=rtn.split("^")
					if(rtnArr[0]!=0){
						alert(rtnArr[1]);
					}else{
						alert("退号成功");
						findPatientTree();	
					}
					
				}
			}
		}*/
		,'-',
			{text:"展开",iconCls:'icon-expand-custom',handler:function(b, e){
					if(b.text=="展开"){
						b.setText("收起");
						patientTreePanel.setWidth(1300);
						Ext.getCmp("docmainviewport").syncSize();
					}else{
						b.setText("展开");
						patientTreePanel.setWidth(patientTreePanelWidth);
						Ext.getCmp("docmainviewport").syncSize();
					}
				}
			}
		],
		cmHandler:function(cms){
			for(var i = 0, len = cms.length; i < len; i++){		
				if(cms[i].dataIndex == "PAAdmBed"){				
					var bedcm = cms.splice(i,1);
					cms.splice(0,0,bedcm[0]);
				}
				if(cms[i].dataIndex == "IconProfile"){		
					cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){	
						return reservedToHtml(value);
					}
				}
				if(cms[i].dataIndex == "Arrived"){		
					cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){	
						return reservedToHtml(value);
					}
				}
				if (cms[i].dataIndex == "Transfer"){
					cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){	
						return reservedToHtml(value);
					}
				}
				if(cms[i].dataIndex == "PAPMIName"){		
					cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){	
						return reservedToHtml(value);
					}
				}
				if(cms[i].dataIndex == "LocSeqNo"){		
					cms[i]["renderer"] = function(value, metaData, record, rowIndex, colIndex, store){	
						return reservedToHtml(value);
					}
				}
					
			}
			return cms;
		},
		listeners:{
			'afterrender': function(t){ 
				t.store.baseParams.P1 =""   //typeCombo.getValue();
				//PAADMType菜单内的参数
				if("undefined"==typeof PAADMType)t.store.baseParams.P5 = "I";
				else t.store.baseParams.P5 = PAADMType;
				
				 var ArrivedQue=document.getElementById("ArrivedQue").checked;
				var RegQue=document.getElementById("RegQue").checked;
				var Consultation=document.getElementById("Consultation").checked;
				var AllPatient=document.getElementById("AllPatient").checked;
				if(ArrivedQue){
					ArrivedQue="on"
				}else{
					ArrivedQue=""	
				}
				if(RegQue){
					RegQue="on"
				}else{
					RegQue=""	
				}
				if(Consultation){
					Consultation="on"
				}else{
					Consultation=""	
				}
				if(AllPatient){
					AllPatient="on"
				}else{
					AllPatient=""	
				}
				t.store.baseParams.P9 = ArrivedQue
				t.store.baseParams.P10 = RegQue
				t.store.baseParams.P11 = Consultation
				t.store.baseParams.P12 =AllPatient
				t.store.baseParams.P14 =Ext.getCmp("MarkList").getValue()
				
				t.store.on("load",function(t, records, options){
					var ArrivedQue=document.getElementById("ArrivedQue").checked;
					var RegQue=document.getElementById("RegQue").checked;
					//var AllPatient=document.getElementById("AllPatient").checked;
					
					var QueType="全部就诊:" ;
					if (ArrivedQue)QueType="已就诊: "
					if (RegQue)QueType="未就诊: "
					//if (AllPatient)QueType="全部就诊: "
					//<span class='icon-tablelist-custom'>'  '</span>"+"&nbsp;&nbsp;&nbsp;&nbsp					
					patientTreePanel.setTitle("<img src='/dthealth/web/images/uiimages/tablelist.png' style='vertical-align:middle;'>&nbsp;&nbsp;患者列表&nbsp;&nbsp;&nbsp;&nbsp"+ "<font color=red>"+QueType+t.getTotalCount()+"人"+"</font>")	
				})
				
				t.store.load();
			},
			'pagingToolbarRender': function(){
				AdmDayBar.render(this.tbar);
				MarkList.render(this.tbar);					
				patientQueryBar.render(this.tbar);
				patientQueryNameBar.render(this.tbar);
				patientQueryMedicalBar.render(this.tbar);
				patientQueryCardNoBar.render(this.tbar);
				patientQueryCardType.render(this.tbar);
				StartDateBar.render(this.tbar);
				//设置默认的号别session
				var GetSessionObj=document.getElementById('GetSessionDataMethod');
				if (GetSessionObj) {var encmeth=GetSessionObj.value} else {var encmeth=''};
				if (encmeth!=""){
					var MarkSelectDr=cspRunServerMethod(encmeth,"MarkSelectDr")
					Ext.getCmp("MarkList").setValue(MarkSelectDr)
				}
				
				
			}
		},
		columnModelFieldJson: patientTreeMetaDataJson		
	});	
	patientTreePanel.getView().getRowClass=function(record,rowIndex,rowParams,store){
			var CallLable=""
			var PAPMINO=record.get("PAPMINO")
			var WalkStatus=record.get("StatusCode")
			var DocDr=record.get("PAAdmDocCodeDR");
			var Called=record.get("Called");
			if ((DocDr!="")&&(DocDr!=" ")&&(WalkStatus!='04')) {
			if (WalkStatus=="01")	{
				return 'clsRowAgain';
			}
			if (CallLable=="")	{
				if (Called=="1")	{
					 return 'x-grid-record-row';
				}
				if (Called=="2")	{
					return 'clsRowCalledWait';
				}
				
			}				
		}
		return "" //'x-grid-record-row';	
	}
	if(PAADMType && PAADMType=="I") {
		patientTreePanel.getTopToolbar().items.get(5).hide()
		patientTreePanel.getTopToolbar().items.get(6).hide()
		patientTreePanel.getTopToolbar().items.get(7).hide()
		patientTreePanel.getTopToolbar().items.get(8).hide()
		patientQueryBar.items.get(2).hide()
		patientQueryBar.items.get(3).hide()
		patientQueryBar.items.get(4).hide()
		patientQueryBar.items.get(5).hide()
		patientQueryBar.items.get(6).hide()
		patientQueryNameBar.items.get(2).hide()
		patientQueryNameBar.items.get(3).hide()
		patientQueryNameBar.items.get(4).hide()
		patientQueryNameBar.items.get(5).hide()
		patientQueryNameBar.items.get(6).hide()
		patientQueryMedicalBar.items.get(2).hide()
		patientQueryMedicalBar.items.get(3).hide()
		patientQueryMedicalBar.items.get(4).hide()
		patientQueryMedicalBar.items.get(5).hide()
		patientQueryMedicalBar.items.get(6).hide()
		MarkList.hide();
	}
	//门诊和住院的病人信息显示的不一样
	//暂时取消门诊体重
	//'体重:',{xtype: 'tbtext',id:'baseInfoBodyWeight',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},'-',
	if(PAADMType && (PAADMType=="O")||(PAADMType=="E")) {
		if (LengthMark==1){MarkList.hide();}
		patienttabPanelBar = [
			{xtype: 'tbtext',id:'baseIconProfile',text:''},	"-",
			'登记号:',{xtype: 'tbtext',id:'baseInfoNo',width:'100',text:'',style:'font-weight:bold;font-size:16px;'},"-",	
			'卡号:',{xtype: 'tbtext',id:'baseInfoCardNo',width:'100',text:'',style:'font-weight:bold;font-size:16px;'},"-",			
	        '姓名:',{xtype: 'tbtext',id:'baseInfoName',width:'100',text:'',style:'font-weight:bold;font-size:16px;'},"-",
			'性别:',{xtype: 'tbtext',id:'baseInfoSex',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},"-",
			'年龄:',{xtype: 'tbtext',id:'baseInfoAge',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},"-",
			'病人类型:',{xtype: 'tbtext',id:'baseInfoInsu',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},'-',
			//'过敏史:',{xtype:'tbtext',id:'basePatAllergy',style:'color:red;'},'-',
			{xtype: 'tbtext',id:'baseIsEstDisch',text:'',hidden:true}
			]
	}else{
		patienttabPanelBar = [
			{xtype: 'tbtext',id:'baseIconProfile',text:''},	"-",			
	        '姓名:',{xtype: 'tbtext',id:'baseInfoName',width: '100',text:'',style:'font-weight:bold;font-size:16px;'},"-",
	        '床号:',{xtype: 'tbtext',id:'baseInfoBedno',width:'70',text:'',style:'font-weight:bold;font-size:16px;'},"-",
	        '年龄:',{xtype: 'tbtext',id:'baseInfoAge',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},"-",
			'性别:',{xtype: 'tbtext',id:'baseInfoSex',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},"-",
	        '体重:',{xtype: 'tbtext',id:'baseInfoBodyWeight',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},'-',
			'住院号:',{xtype: 'tbtext',id:'baseInfoIPNo',width:'100',text:'',style:'font-weight:bold;font-size:16px;'},'-',
			'病人类型:',{xtype: 'tbtext',id:'baseInfoInsu',width:'50',text:'',style:'font-weight:bold;font-size:16px;'},'-',
			'入院日期:',{xtype: 'tbtext',id:'baseInfoIPDate',width:'100',text:'',style:'font-weight:bold;font-size:16px;'},'-',
			'过敏史:',{xtype:'tbtext',id:'basePatAllergy',style:'color:red;'},'-',
			{xtype: 'tbtext',id:'baseIsEstDisch',text:'',hidden:true}
			]
	}
	var tabPanel = new Ext.TabPanel({	
		activeTab:0,
		id: 'DHCDocTabPanel',
		enableTabScroll:true,
		minTabWidth: 115,
        tabWidth:135,
		region:'center',
		items:tabItemsJson,
		listeners:{"afterrender": function(tp){
			var frm = dhcsys_getmenuform();
			if(frm.EpisodeID.value!=""){
				//refreshBar();
				var p = tp.getActiveTab();
				isVaildUseDHCOE(p)
				if (p.allRefresh === true){						
					hrefRefresh(true);
				}else{
					//xhrRefresh(forceRefresh);  局部刷新让页面自己去做
				}
			}
		}}		
		//tbar内的item的id与后台一样
		//tbar: patienttabPanelBar
	});	
	var viewport = new Ext.Viewport({
		id:'docmainviewport',
		layout:'border',
		items:[patientInfoPanel,patientTreePanel,tabPanel]
	});
}
function CardNoKeyDown(){
	var CardNo=Ext.getCmp("patientCardNoTF").getValue()
	if (CardNo=="") return;
	var myoptval=Ext.getCmp("CardTypeDefine").getValue();
	var myary=myoptval.split("^");
	var m_CardNoLength=myary[17]
	if ((CardNo.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
		for (var i=(m_CardNoLength-CardNo.length-1); i>=0; i--) {
			CardNo="0"+CardNo;
			//alert(CardNo)
		}
	}
	var CardTypeRowId=myary[0];
	Ext.getCmp("patientCardNoTF").setValue(CardNo)
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
	//var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo");
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];
	//alert(myrtn)

	switch (rtn){
		case "-200": //卡无效
			alert("卡无效");
			Ext.getCmp("patientNoTF").setValue("")
			break;
		default:
			//alert(myrtn)
			Ext.getCmp("patientNoTF").setValue(myary[5])
			break;
	}
}
var initListener = function(){
	var obj = Ext.getCmp("typeCb");
	if (obj) {		
		obj.on("select",function(cb,r,index){			
			var store = patientTreePanel.store;
			var v = cb.getValue();
			//P1=type P2=patientNo
			if(store.baseParams.P1 != v){				
				Ext.getCmp('patientNoTF').setValue("");
				store.baseParams.P1 = v;
				store.baseParams.P2 = "";Ext.getCmp('patientNoTF').setValue("");
				store.baseParams.P3 = "";Ext.getCmp('patientNameTF').setValue("");
				store.baseParams.P4 = "";Ext.getCmp('patientMedicalTF').setValue("");
				store.baseParams.P6 = "";Ext.getCmp('patientCardNoTF').setValue("");
				store.load();
				resetEprMenuForm();
			}
		});
	}
	var obj = Ext.getCmp("patientNoTF");
	if(obj){
		obj.on("keypress",function(t,e){
			if(e.getKey() == e.ENTER){
				CardNoKeyDown()
				findPatientTree(e);
			}
		});
	}
	var obj = Ext.getCmp("AdmDayLimit");
	if(obj){
		obj.on("keypress",function(t,e){
			if(e.getKey() == e.ENTER){
				document.getElementById('RegQue').checked=false;
				document.getElementById('ArrivedQue').checked=false;
				document.getElementById('AllPatient').checked=false;
				document.getElementById('Consultation').checked=false;
				//document.getElementById('AdmStartDate').value="";
				//document.getElementById('AdmEndDate').value="";
				Ext.getCmp('AdmStartDate').setValue(new Date);
				Ext.getCmp('AdmEndDate').setValue(new Date);
				findPatientTree(e);
			}
		});
	}
	var obj = Ext.getCmp("AdmEndDate");
	if(obj){
		obj.on("select",function(t,e){
			document.getElementById('AdmDayLimit').value="";
			document.getElementById('RegQue').checked=false;
			document.getElementById('ArrivedQue').checked=false;
			document.getElementById('AllPatient').checked=false;
			document.getElementById('Consultation').checked=false;
			findPatientTree(e);
		});
	}
	var obj = Ext.getCmp("AdmStartDate");
	if(obj){
		obj.on("select",function(t,e){
			document.getElementById('AdmDayLimit').value="";
			document.getElementById('RegQue').checked=false;
			document.getElementById('ArrivedQue').checked=false;
			document.getElementById('AllPatient').checked=false;
			document.getElementById('Consultation').checked=false;
			findPatientTree(e);
		});
	}
	var obj = Ext.getCmp("AdmReqNo");
	if(obj){
		obj.on("keypress",function(t,e){
			if(e.getKey() == e.ENTER){
				document.getElementById('RegQue').checked=false;
				document.getElementById('ArrivedQue').checked=false;
				document.getElementById('AllPatient').checked=false;
				document.getElementById('Consultation').checked=false;
				findPatientTree(e);
			}
		});
	}
	var obj = Ext.getCmp("patientCardNoTF");
	if(obj){
		obj.on("keypress",function(t,e){
			if(e.getKey() == e.ENTER){
				
				findPatientTree(e);
			}
		});
	}
	
	var obj = Ext.getCmp("patientNameTF");
	if(obj){
		obj.on("keypress",function(t,e){
			if(e.getKey() == e.ENTER){
				findPatientTree(e);
			}
		})
	}
	var obj = Ext.getCmp("patientMedicalTF");
	if(obj){
		obj.on("keypress",function(t,e){
			if(e.getKey() == e.ENTER){
				findPatientTree(e);
			}
		})
	}
	var obj = Ext.getCmp("patientCardNoTF");
	if(obj){
		obj.on("keypress",function(t,e){
			if(e.getKey() == e.ENTER){
				findPatientTree(e);
			}
		})
	}
	if(patientTreePanel){
		patientTreePanel.on("rowclick",function (t, index, e){
			var r = t.store.getAt(index);
			gridPanelClick(r,true);			
		});
		//双击为强制刷新
		patientTreePanel.on("rowdblclick",function(t,index,e){
			var r = t.store.getAt(index);
			gridPanelClick(r,true);
		});
		patientTreePanel.store.on("load",function(s, rs,op){
			var EpisodeID = "",index = -1;
			//if(rs.length>0){hideQueryBar();}
			s.each(function(r,i){
				if(r.data["BGColor"]!="") {
					patientTreePanel.getView().getRow(i).style.backgroundColor = r.data["BGColor"];
				}
			})
			
			/*
			var count = s.getCount();
			if(count==1){
				patientTreePanel.getSelectionModel().selectRow(0);
				var r = patientTreePanel.store.getAt(0);
				setTimeout(function(){gridPanelClick(r,true);},0)
			}
			*/
			var findAdm=0;
			var frm = dhcsys_getmenuform();
			if (frm) {
				EpisodeID = frm.EpisodeID.value ;				
				if( (EpisodeID != "") && (EpisodeID != 0) ){
					Ext.each(rs,function(r,i){if(r.data["EpisodeID"]==EpisodeID){index = i;findAdm=1;return i;}});
					if(index>=0){
						patientTreePanel.getSelectionModel().selectRow(index);
						//当发送事件时医嘱列表可能没有煊染完成,医嘱列表第一次加载时去判断病人并查询					
						//patientTreePanel.fireEvent("rowdblclick",patientTreePanel,index,{});
					}
				}
			}
			if ((findAdm==0)&&(isTimeFresh==0)){
				setTimeout(SelectOnlyPat,100)
			}
		});	
		patientTreePanel.getSelectionModel().on("beforerowselect",function(SelectionModel,rowIndex,keepExisting,record){
			
				var DoingSth=getSysMenuDoingSth()
				//window.status="DoingSth="+DoingSth+"AA"
				if(DoingSth!=""){
					var selr = patientTreePanel.getStore().getAt(rowIndex);
					var seladm=selr.data["EpisodeID"]
					var frm = dhcsys_getmenuform();
					var adm = frm.EpisodeID.value ;		
					//if((adm!="")&&(adm!=seladm)){
					if((adm!=seladm)){
						alert(DoingSth)   //+" adm="+adm+"  seladm="+seladm)	
						return false	
					}
					return false
				}	
				return true
		})
		
			
	}
	var obj = Ext.getCmp('DHCDocTabPanel');
	if (obj){
		/*obj.on("beforetabchange",function (tp,p,cPanel){
			var frm = dhcsys_getmenuform();
			if(isVaildUseDHCOE(p)){
				setTimeout(hideLoadingWinFun,100);
				if(!p.html) {p.html = '<iframe id="'+ p.frameName +'" name="'+ p.frameName +'" src="'+ p.src +'" width=100% height=100% ></iframe>';}				
			}else{
				return false;
			}			
		})*/
		obj.on("beforetabchange",function (tp,p,cPanel){
			var DoingSthObj = dhcsys_getmenuform().DoingSth;
			if (DoingSthObj && DoingSthObj.value!=""){
				alert(DoingSthObj.value);
				return false;
			}
			if (typeof(cPanel) == 'undefined' || typeof(cPanel.frameName) == 'undefined') return true;
			var frm = dhcsys_getmenuform();
			var frame = window.frames[cPanel.frameName];		
			if ( frame ){
				var chartOnBlur = "";
				if ("function" === typeof frame.chartOnBlur){
					chartOnBlur = frame.chartOnBlur; 
				}else if (frame.contentWindow && "function" === typeof frame.contentWindow.chartOnBlur){
					chartOnBlur = frame.contentWindow.chartOnBlur;
				}
				if(chartOnBlur) {
					//如果返回非true,不切换Chart
					if (!chartOnBlur()){return false;};	
			    }			
			}	
			//--------------			
			if (typeof(p) == 'undefined' || typeof(p.frameName) == 'undefined') return true;
			var newTabframe = window.frames[p.frameName];		
			if ( newTabframe ){
				var chartOnFocus = "";
				if ("function" === typeof newTabframe.chartOnFocus){
					chartOnFocus = newTabframe.chartOnFocus; 
				}else if (newTabframe.contentWindow && "function" === typeof newTabframe.contentWindow.chartOnFocus){
					chartOnFocus = newTabframe.contentWindow.chartOnFocus;
				}
				if(chartOnFocus) {
					var papmi="",adm="",mradm="";
					if (frm) {
						papmi = frm.PatientID.value;
						adm = frm.EpisodeID.value; 
						mradm = frm.mradm.value; 
					}
				    chartOnFocus({papmi: papmi, adm: adm, mradm: mradm});	
				}			
			}
			if(isVaildUseDHCOE(p)){
				if(pbar) {setTimeout(hideLoadingWinFun,100);}
				if(!p.html) {p.html = '<iframe id="'+ p.frameName +'" name="'+ p.frameName +'" src="'+ p.src +'" width=100% height=100% ></iframe>';}				
			}else{
				return false;
			}
			return true;					
						
		});		
		obj.on("tabchange",function(tp,p){
			//解病人锁
			tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
			var frm = dhcsys_getmenuform();
			if(p.allRefresh === true){			
				if ( frm.EpisodeID.value > 0){
					hrefRefresh(true);
				}
			}else{
				xhrRefresh(true);
			}	
		})
	}
};
function ArrivedQue_OnClick(){
	// 修改互斥 zzz 20160819 
	if (document.getElementById('ArrivedQue').checked){
		document.getElementById('RegQue').checked=false;
	}else{
		document.getElementById('RegQue').checked=true;
	}
	//document.getElementById('RegQue').checked=false;
	document.getElementById('AllPatient').checked=false;
	document.getElementById('Consultation').checked=false;
	findPatientTree();
}
function RegQue_OnClick(){
	
	if (document.getElementById('RegQue').checked){
		document.getElementById('ArrivedQue').checked=false;
	}else{
		document.getElementById('ArrivedQue').checked=true;
	}
	//document.getElementById('ArrivedQue').checked=false;
	document.getElementById('AllPatient').checked=false;
	document.getElementById('Consultation').checked=false;
	findPatientTree();
}
function AllPatient_OnClick(){
	document.getElementById('ArrivedQue').checked=false;
	document.getElementById('RegQue').checked=false;
	document.getElementById('Consultation').checked=false;
	findPatientTree();
}
function Consultation_OnClick(){
	document.getElementById('ArrivedQue').checked=false;
	document.getElementById('RegQue').checked=false;
	document.getElementById('AllPatient').checked=false;
	document.getElementById('AdmDayLimit').value="";
	findPatientTree();
}
function PatTransfer(){
	var r = patientTreePanel.getSelectionModel().getSelected();
	var EpisodeID=r.get("EpisodeID")
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCDoc.Transfer&EpisodeID="+EpisodeID+"&LocID="+session['LOGON.CTLOCID']+"&UserID="+session['LOGON.USERID'];
	window.open(url,"","status=1,scrollbars=1,top=100,left=100,width=760,height=420");	
}
function SetPatArrived(){
	//把病人置到达
	var r = patientTreePanel.getSelectionModel().getSelected();
	var AdmDate=r.get("PAAdmDate")
	if (CheckAdmDate(AdmDate)==false) {
		alert('请选择当日就诊病人')
		return false;
	}
	/*var CalledStatus=r.get("Called")
	if (CalledStatus!='1') {
		var StatusDesc=r.get("WalkStatus")
		alert("不能置为到达,病人当前状态为"+StatusDesc)
		return false;
	}*/
	var EpisodeID=r.get("EpisodeID")
	var DoctorId=LogonDocDr //DoctorId=r.get("RegDocDr")
	var LocId=session['LOGON.CTLOCID']
	var UserId=session['LOGON.USERID']
	var Stat=cspRunServerMethod(SetArrivedStatus,EpisodeID,DoctorId,LocId,UserId);
	if (Stat!='1')	{
		alert("状态更新失败");
		return false;
	}
	var ArrivedQueObj=document.getElementById("ArrivedQue")
	ArrivedQueObj.checked=true;
	var RegQueObj=document.getElementById("RegQue")
	RegQueObj.checked=false;
	findPatientTree();
}

var init = function(){
	//resetEprMenuForm();
	initComp();
	initListener();
	document.getElementById("RegQue").onclick=RegQue_OnClick
	document.getElementById("AllPatient").onclick=AllPatient_OnClick
	document.getElementById("ArrivedQue").onclick=ArrivedQue_OnClick
	document.getElementById("Consultation").onclick=Consultation_OnClick
	//if((PAADMType)&&(PAADMType=="O")){
		window.setTimeout(findPatientTree1,120000);
	if(session["LOGON.GROUPID"]==21){
		showQueryBar()
	}
	if(session["LOGON.GROUPID"]!=32){
	  //Ext.getCmp('ReturnNumber').setVisible(false);
	}
	//showQueryBar()
	//}
};
/*function DHCHardComm_RandomCardEquip(CardType, FunctionType, InPara1, InPara2, InPara3)
{
	var myrtn="0";
	switch (FunctionType) {
	case "R":
		switch (CardType) {
		case "2":
			var myobj=document.getElementById("ClsReadCard");
			if (myobj)
			{
				myrtn = myobj.ReadCard(InPara1)
			}
			break;
			
		case "3":
			var myobj=document.getElementById("ClsHTCard");
			if (myobj)
			{
				myrtn = myobj.ReadMagCard(InPara1)
			}
			break;
			
		}
		break;
	case "W":
		switch (CardType) {
		case "2":
			var myobj=document.getElementById("ClsReadCard");
			if (myobj)
			{
				myrtn = myobj.WriteCard(InPara1, InPara2, InPara3)
			}
			break;
			
		}
		break;
	}
	return myrtn;
}*/
function DHCAMSCallPat(){
	var r = patientTreePanel.getSelectionModel().getSelected();
	var AdmDate=r.get("PAAdmDate")
	if (CheckAdmDate(AdmDate)==false) {
		alert("请选择当日就诊病人")
		return false;
	}
	var PAPMIName=r.get("PAPMIName")
	if(PAPMIName.indexOf("</A>")>=0){
		PAPMIName=PAPMIName.split("</A>")[0].split(">")[1]	
	}	
	var EpisodeID=r.get("EpisodeID")
	DHCAMSCall(EpisodeID)
}
function NewCallPatient()	{
	///调用叫号公司的webervice进行呼叫
	/*var ret=tkMakeServerCall("web.DHCDocOutPatientList","SendCallInfo",session["LOGON.USERID"])
	var retArr=ret.split("^")
	if(retArr[0]=="0"){
		alert(retArr[1])
		//Find_click();	
		findPatientTree1()
		return true
	}else{
		alert(retArr[1])
		return false
	}*/
	///web.DHCVISQueueManage.RunNextButton
	var nextButtonJs=document.getElementById('nextButtonJs');
	if (nextButtonJs) {var encmeth=nextButtonJs.value} else {var encmeth=''};
	var IPAddress=GetComputerIp()
	if((IPAddress!="Exception")&&(IPAddress!="")){
		var alertCode=cspRunServerMethod(encmeth,"","",IPAddress)
	}else{
	    var alertCode=cspRunServerMethod(encmeth)
	}
	if(alertCode=="") {
		findPatientTree();
		return true;
	}
	else  return false;
}
function GetComputerIp() 
{
   var ipAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");
   //连接本机服务器
   var service = locator.ConnectServer(".");
   //查询使用SQL标准 
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");
   var e = new Enumerator (properties);
   var p = e.item ();

   for (;!e.atEnd();e.moveNext ())  
   {
		var p = e.item ();
		//IP地址为数组类型,子网俺码及默认网关亦同
		//document.write("IP:" + p.IPAddress(0) + " ");
		ipAddr=p.IPAddress(0);
		if(ipAddr) break;
	}
	return ipAddr;
}
function ReCallPatient()	{
	///调用叫号公司的webervice进行重复呼叫
	/*var ret=tkMakeServerCall("web.DHCDocOutPatientList","SendReCallInfo",session["LOGON.USERID"])
	var retArr=ret.split("^")
	if(retArr[0]=="0"){
		alert(retArr[1])
		//Find_click();	
	}else{
		alert(retArr[1])
		return 	
	}*/
	var recall=document.getElementById('recall');
	if (recall) {var encmeth=recall.value} else {var encmeth=''};
	var IPAddress=GetComputerIp()
	if((IPAddress!="Exception")&&(IPAddress!="")){
		var alertCode=cspRunServerMethod(encmeth,"","",IPAddress)
	}else{
	  var alertCode=cspRunServerMethod(encmeth)
	}
	if(alertCode=="") return true;
	else  return false;
}

Ext.onReady(init);

function switchTabByEMR(flag) {
	var tab = Ext.getCmp('DHCDocTabPanel');
	if (tab){	
		if ('diag'==flag) {
			tab.setActiveTab('dataframe193');
		} else if ('oeord'==flag) {
			tab.setActiveTab('dataframe184');
		} else if ('zoeord'==flag) {
			tab.setActiveTab('dataframe25');
		}
	}
}

function updateEMRInstanceData(flag, content) {
	content = content.replace(/&nbsp/g, "");
	window.frames['dataframe165'].updateEMRInstanceData(flag, content);		
}
function CheckAdmDate(AdmDate)	{
	//return true;    //when don't need check AdmDate, return true
	var ToDay= new Date();
	var Year=ToDay.getFullYear();
	var Month=ToDay.getMonth();
	Month=Month+1;
	if (Month<10) {Month='0'+Month;}
	var Day=ToDay.getDate();
	if (Day<10) Day='0'+Day;
	if (DateFormat==3)  var StrDate=Year+'-'+Month+'-'+Day;
	if (DateFormat==4)  var StrDate=Day+"/"+Month+'/'+Year;
	if (StrDate==AdmDate) {return true}
	else  {return false;}	
}

function invokeChartFun(tabName,funName){
	Ext.each(tabItemsJson,function(r,ind){
		if (r.title.trim()==tabName.trim()){
			var newTabframe = window.frames[r.frameName];
			if ( newTabframe ){
				var fun = "";
				if ("function" === typeof newTabframe[funName]){
					fun = newTabframe[funName]; 
				}else if (newTabframe.contentWindow && "function" === typeof newTabframe.contentWindow[funName]){
					fun = newTabframe.contentWindow[funName];
				}
				if(fun) {
					var args=[],j=0;
					for (var i=2; i<invokeChartFun.arguments.length; i++) {
						//alert(invokeChartFun.arguments[i]);
						args[j++]=invokeChartFun.arguments[i];
					}
					fun.apply(newTabframe,args);
				}			
			}
			return ;
		}
	}); 
	return ;
}

function switchTabByEMR(flag) {
	var tab = Ext.getCmp('DHCDocTabPanel');
	if (tab) {
		Ext.each(tabItemsJson, function (r, ind) {
			if (r.title.trim() == flag.trim()) {
				tab.setActiveTab(r.id);
				return;
			}
		});
	}
}
function callButton_click() {
	var r = patientTreePanel.getSelectionModel().getSelected();
	if(r){
		var PAPMIName=r.get("PAPMIName")
		if(PAPMIName.indexOf("</A>")>=0){
			PAPMIName=PAPMIName.split("</A>")[0].split(">")[1]	
		}
		if(PAPMIName.indexOf("&lt;/A&gt;")>=0){
			PAPMIName=PAPMIName.split("&lt;/A&gt;")[0].split("&gt;")[1]	
		}
		var LocSeqNo=r.get("LocSeqNo")
		if(LocSeqNo.indexOf("</A>")>=0){
			LocSeqNo=LocSeqNo.split("</A>")[0].split(">")[1]	
		}
		if(LocSeqNo.indexOf("&lt;/A&gt;")>=0){
			LocSeqNo=LocSeqNo.split("&lt;/A&gt;")[0].split("&gt;")[1]	
		}
		alert("正在呼叫"+LocSeqNo+"号 "+PAPMIName)
	}
	

}
//通过cspname类型chart配置取chart的color与数量
var getChartItemsInfo = function(PatientId,EpisodeId,mradm){
	Ext.Ajax.request({
	   url: "ext.websys.datatrans.csp",
	   success: function(res,opts){
		   var rtn = res.responseText.replace(/\r\n/g,"");
		   if (rtn!=""){	  
				var obj = Ext.decode(rtn);
				if (obj){
					var tabs = Ext.getCmp('DHCDocTabPanel');
					var len = tabs.items.length;
					for(var i=0; i<len; i++){
						var tabsItemEl = tabs.getTabEl(i);
						// 清除特殊样式
						if(tabsItemEl.className.indexOf("x-tab-strip-active")>-1) {
							tabsItemEl.className = "x-tab-strip-active";
						}else{
							tabsItemEl.className = "";
						}
						tabs.getItem(i).setTitle(tabItemsJson[i]["title"]);
						if (obj[i]){
							var itemStyleObj = obj[i];
							// 设置样式
							if (itemStyleObj["className"]) Ext.fly(tabsItemEl).addClass(itemStyleObj.className);
							if (itemStyleObj["count"]) tabs.getItem(i).setTitle(itemStyleObj.tabTitle+'('+itemStyleObj.count+')');
						}
					}
				}
		   }
		},
	   failure: function(res,opts){},
	   params: {
		   pClassName:"epr.Chart",
		   pClassMethod:"GetPatChartInfo",
		   ChartBookID:ChartBookID,
		   PatientId:PatientId,
		   EpisodeId:EpisodeId,
		   mradm:mradm
		}
	});
}
function getSysMenuDoingSth() {
    if ('undefined' != typeof dhcsys_getmenuform) {
        var DoingSth = dhcsys_getmenuform().DoingSth || '';
        if ('' != DoingSth)
            return DoingSth.value || '';
    }
    return '';
}
function CheckSelectPat(){
	var DoingSth=getSysMenuDoingSth()
	if(DoingSth!=""){
		//alert(DoingSth)
		
		var selr = patientTreePanel.getSelectionModel().getSelected();
		var seladm=selr.get("EpisodeID")
		var frm = dhcsys_getmenuform();
		var adm=""
		patientTreePanel.getSelectionModel().clearSelections()
		if (frm) {
			adm = frm.EpisodeID.value ;				
			if( (adm != "") && (adm != 0) ){
				var store = patientTreePanel.getStore(); 
				var count = store.getCount();
				for(var i=0;i<count;i++){
					var r=store.getAt(i)
					if(r.data["EpisodeID"]==adm){
						patientTreePanel.getSelectionModel().selectRow(i);
						break;
					}	
				}
			}
		}		
		if((adm!="")&&(adm!=seladm)){
			alert(DoingSth)   //+" adm="+adm+"  seladm="+seladm)		
		}
		return false	
	}
	return true
}

function SelectOnlyPat(){
	if(patientTreePanel){
		var frm = dhcsys_getmenuform();
		if (frm) {
			var adm = frm.EpisodeID.value; 
			if (adm!="") return;
		}
		var pstore = patientTreePanel.store;	
		var count = pstore.getCount();
		debugger;
		if(count==1){
			patientTreePanel.getSelectionModel().selectRow(0);
			var r = pstore.getAt(0);
			setTimeout(function(){gridPanelClick(r,true);},0)
		}
	}
}