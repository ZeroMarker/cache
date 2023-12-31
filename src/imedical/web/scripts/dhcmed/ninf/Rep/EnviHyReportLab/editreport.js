
function InputEnviHyRst(ReportID,EditFlg){
	if (!ReportID) return;
	var objReport = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","GetObjById",ReportID);
	if (!objReport) return;
	var ItemObj = objReport.EHRItemObj;
	var EHRItem = objReport.EHRItem;
	var objItem = ExtTool.RunServerMethod("DHCMed.NINF.Dic.EnviHyItem","GetObjById",EHRItem);
	if (!objItem) return;
	var ItemDesc=objItem.EHIDesc;
	var EnviHyNorm = objReport.EnviHyNorm;
	var objNorm = ExtTool.RunServerMethod("DHCMed.NINF.Dic.EnviHyNorms","GetObjById",EnviHyNorm);
	if (!objNorm) return;
	var NormDesc = objNorm.EHNNorm;
	var NormRange = objNorm.EHNRange;
	var SpecimenNum = objNorm.SpecimenNum;
	var CenterNum = objNorm.CenterNum;
	var SurroundNum = objNorm.SurroundNum;
	SpecimenNum = SpecimenNum*1;
	CenterNum = CenterNum*1;
	SurroundNum = SurroundNum*1;
	var itemResultArray = new Array();
	var itemResultGenArray = new Array();
	var itemResult = objReport.EHRResult;
	var itemPathogens = objReport.EHRPathogens;
	if(itemResult!=""){
		itemResultArray = itemResult.split(",");
	}
	if(itemPathogens!=""){
		itemResultGenArray = itemPathogens.split(",");
	}
	
	var htmlStr = ""
	htmlStr += "<table align='center' cellpadding='0' cellspacing='0' width='100%' border='1'>"
	+"<caption align='top' style='font-size:14;font-weight:bold;text-align:center'>"
	+ ItemDesc + "<br/>"
	+ NormRange + "&nbsp;&nbsp;&nbsp;&nbsp;" + ItemObj + "<br/>"
	+ "结果【" + NormDesc + '】'
	+ "</caption>"
	+ "<tr align='center'><td align='right'>采样点</td><td>菌落数</td><td  align='left'>检出致病菌</td></td></tr>";
	for(var i=1;i<=SpecimenNum;i++){
		var SubItemNo = i;
		var SubItemDesc = '';
		if ((CenterNum>0)&&(i<=CenterNum)){
			SubItemDesc = "中心-" + SubItemNo;
		} else if ((SurroundNum>0)&&(i<=(SurroundNum+CenterNum))){
			SubItemDesc = "周边-" + SubItemNo;
		} else if ((CenterNum>0)||(SurroundNum>0)) {
			SubItemDesc = "参照-" + SubItemNo;
		} else {
			SubItemDesc = "检测-" + SubItemNo;
		}
		
		var strItemResult = '';
		if (itemResultArray.length>=i) {
			strItemResult = itemResultArray[i-1];
		}
		var strItemResultGen = '';
		if (itemResultGenArray.length>=i) {
			strItemResultGen = itemResultGenArray[i-1];
		}
		htmlStr +="<tr  align='center'><td  align='right'>" + SubItemDesc + "：</td>"
		+ "<td><input type='text' size='5' onkeyup='value=value.replace(/[^\\d]/g,\"\")' onkeydown='getFocus(\"itemResult"+(i+1)+"\")' value='"+strItemResult+"' id='"+("itemResult"+i)+"'/></td>"
		+ "<td align='left'><input type='text' value='"+strItemResultGen+"' id='"+("itemResultGen"+i)+"'/></td></tr>";
	}
	htmlStr +="</table>"
	
	var row = SpecimenNum;
	if (row<2) row = 2;
	if (row>9) row = 9;
	var winRowEditer = Ext.getCmp('EnviHyReport_RowEditer');
	if (!winRowEditer){
		winRowEditer = new Ext.Window({
			id : 'EnviHyReport_RowEditer',
			height : (180+35*row),
			width :450, 
			closeAction: 'close',
			modal : true,
			title : '结果录入',
			layout : 'fit',
			resizable : false,
			items: [{
					layout : 'form',
					labelAlign : 'center',
					labelWidth : 70,
					autoScroll : true,
					frame : true,
					html:htmlStr
			}],
			bbar : [
				'->',
				new Ext.Toolbar.Button({
					id: "EnviHyReport_RowEditer_btnUpdate",
					iconCls : 'icon-save',
					width : 60,
					text : "保存",
					listeners : {
						'click' : function(){
							var arrResult = new Array();
							var arrResultTMP = new Array();
							var arrResultGen = new Array();
							for (var indRst = 0; indRst < SpecimenNum; indRst++) {
								arrResult[indRst] = '';
								var objCmp = document.getElementById("itemResult"+(indRst+1));
								if (objCmp){
									var tmpResult = objCmp.value;
									if (tmpResult != ''){
										arrResult[indRst] = tmpResult*1;
									}
								}
								arrResultGen[indRst] = '';
								var objCmp = document.getElementById("itemResultGen"+(indRst+1));
								if (objCmp){
									var tmpResultGen = objCmp.value;
									if (tmpResultGen != ''){
										arrResultGen[indRst] = tmpResultGen;
									}
								}
							}
							
							var inputStr = ReportID;
							inputStr = inputStr + CHR_1 + 4;
							inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
							inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
							inputStr = inputStr + CHR_1 + arrResult.join(CHR_2);
							inputStr = inputStr + CHR_1 + arrResultGen.join(CHR_2);
							var  flg = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","InputEnviHyResult",inputStr,CHR_1+","+CHR_2);
							if (parseInt(flg)==0){
								ExtTool.alert("错误提示","参数错误!");
							} else if (parseInt(flg)<0) {
								ExtTool.alert("错误提示",flg);
							}
							//保存之后不刷新列表，关闭时才刷新
							/*
							else {
								//winRowEditer.close();
								EnviHyRepWindowRefresh_Handler();
							}
							*/
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: "EnviHyReport_RowEditer_btnCheck",
					iconCls : 'icon-check',
					width : 60,
					text : "审核",
					listeners : {
						'click' : function(){
							/* update by zf 2016-02-17
							var inputStr = ReportID;
							inputStr = inputStr + CHR_1 + '';
							inputStr = inputStr + CHR_1 + '';
							inputStr = inputStr + CHR_1 + 5;
							inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
							inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
							var flg = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","SetResultIsNorm",inputStr,CHR_1);
							if (parseInt(flg)<=0) {
								ExtTool.alert("提示","保存数据失败!Error=" + flg);
								return false;
							} else {
								winRowEditer.close();
								EnviHyRepWindowRefresh_Handler();
							}
							*/
							var  StatusInfo= ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","GetStatusByID",ReportID);
							var StatusCode=StatusInfo.split("^")[1];
							if (StatusCode!="4") {
								ExtTool.alert("提示","审核之前先保存!");
								return false;
							}
				  		   
							var arrResult = new Array();
							var arrResultTMP = new Array();
							var arrResultGen = new Array();
							for (var indRst = 0; indRst < SpecimenNum; indRst++) {
								arrResult[indRst] = '';
								var objCmp = document.getElementById("itemResult"+(indRst+1));
								if (objCmp){
									var tmpResult = objCmp.value;
									if (tmpResult != ''){
										arrResult[indRst] = tmpResult*1;
									}else {
										ExtTool.alert("提示","审核之前请完成菌落数录入!");
										return;
									} 
								}
								arrResultGen[indRst] = '';
								var objCmp = document.getElementById("itemResultGen"+(indRst+1));
								if (objCmp){
									var tmpResultGen = objCmp.value;
									if (tmpResultGen != ''){
										arrResultGen[indRst] = tmpResultGen;
									}else {
										ExtTool.alert("提示","审核之前请完成致病菌录入!");
										return;
									} 
								}
							}
							
							var inputStr = ReportID;
							inputStr = inputStr + CHR_1 + 5;
							inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
							inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
							inputStr = inputStr + CHR_1 + arrResult.join(CHR_2);
							inputStr = inputStr + CHR_1 + arrResultGen.join(CHR_2);
							var  flg = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","InputEnviHyResult",inputStr,CHR_1+","+CHR_2);
							if (parseInt(flg)==0){
								ExtTool.alert("错误提示","参数错误!");
							} else if (parseInt(flg)<0) {
								ExtTool.alert("错误提示",flg);
							} else {
								winRowEditer.close();
								EnviHyRepWindowRefresh_Handler();
							}
						}
					}
				}),
				new Ext.Toolbar.Button({
					id: "EnviHyReport_RowEditer_btnCancel",
					iconCls : 'icon-close',
					width : 60,
					text : "关闭",
					listeners : {
						'click' : function(){
							winRowEditer.close();
							EnviHyRepWindowRefresh_Handler();
						}
					}
				})
			]
			,listeners :{
				"beforeclose" : function(){
					//刷新父页面
				},
				"beforeshow" : function(){
					var objCmp = Ext.getCmp('EnviHyReport_RowEditer_btnUpdate');
					var CmpCheck = Ext.getCmp('EnviHyReport_RowEditer_btnCheck');
					if (objCmp) {
						objCmp.setDisabled(!EditFlg);
					}
					if (CmpCheck){
						CmpCheck.setDisabled(!EditFlg);
					}
				}
			}
		});
	}
	winRowEditer.show();
}

function getFocus(CmpId){
	if(this.event.keyCode==9){
		this.event.keyCode=0;
	}
	if (this.event.keyCode!=13){
		return;
	}
	document.getElementById(CmpId).focus();
}

//调用页面刷新
function EnviHyRepWindowRefresh_Handler(){
	if (typeof WindowRefresh_Handler == 'function'){
		WindowRefresh_Handler();
	}
}
