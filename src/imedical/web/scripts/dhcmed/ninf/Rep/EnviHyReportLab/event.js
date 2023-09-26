function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
    {
		obj.gridEnviHyReport.on("rowcontextmenu", obj.gridEnviHyReport_rowcontextmenu, obj);
		Ext.getCmp("mnuResult").on("click", obj.mnuResult_click, obj);
		Ext.getCmp("mnuPrintReport").on("click", obj.mnuPrintReport_click, obj);
		Ext.getCmp("mnuReceive").on("click", obj.mnuReceive_click, obj);
		
		obj.btnMDBat.on("click",obj.btnMDBat_click,obj); //���Ϸ���
		obj.btnPrintBar.on("click",obj.btnPrintBar_click,obj);  //��ӡ����
		obj.cbBar.on("change",obj.cbBar_change,obj);
		obj.txtAreaBar.on("specialkey",obj.txtAreaBar_keydown,obj);
		obj.txtEnviHyResult.on("specialkey",obj.txtEnviHyResult_keydown,obj);
		obj.txtEnviHyPathogen.on("specialkey",obj.txtEnviHyPathogen_keydown,obj);
		
		obj.txtDateFrom.on("select",obj.gridEnviHyReport_LoadByDateLoc,obj);
		obj.txtDateTo.on("select",obj.gridEnviHyReport_LoadByDateLoc,obj);
		obj.cboLoc.on("select",obj.gridEnviHyReport_LoadByDateLoc,obj);
		
    	obj.cboSSHosp.on('expand',obj.cboSSHosp_expand,obj);
		obj.cboSSHosp.on('select',obj.cboSSHosp_Select,obj);
		obj.RowExpander.on("expand",obj.RowExpander_expand,obj);
		
		obj.txtAreaBar.focus(true,true);
		obj.cbBar_change();
		obj.gridEnviHyReport_LoadByDateLoc();
  	};
	
	String.prototype.trim=function() {    
		return this.replace(/(^\s*)|(\s*$)/g,'');
	}
	
	obj.btnPrintBar_click = function(){
		var arrList = obj.gridEnviHyReport.getSelectionModel().getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("��ʾ", "��ѡ�м�¼�����ܴ�ӡ!");
			return;
		}
		
		var strPrinterName = ExtTool.RunServerMethod("DHCMed.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodePrinterName');  //ȡ�����ӡ������
		if (strPrinterName=='') strPrinterName='Zebra';
		var strBarFormat = ExtTool.RunServerMethod("DHCMed.SSService.ConfigSrv","GetValueByKeyHosp",'BarCodeType');  //ȡ�����ӡ��ʽ��������ʽ��
		
		var Bar;
		Bar = new ActiveXObject("DHCMedBarCode.PrintBarEH");
		Bar.PrinterName = strPrinterName;  //��ӡ������
		Bar.PrinterPort = "";            //��ӡ���˿�
		Bar.BarFormat   = strBarFormat;    //����������ʽ���
		
		
		for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
			var objRec = arrList[rowIndex];
			
			var SpecimenNum  = objRec.get("SpecimenNum");
			var CenterNum    = objRec.get("CenterNum");
			var SurroundNum  = objRec.get("SurroundNum");
			var LocDesc      = objRec.get("AskForLocDesc");
			var ItemDesc     = objRec.get("ItemDesc");
			var NormRange    = objRec.get("NormRange");
			var NormObject   = objRec.get("ItemObj");
			var ItemDate     = objRec.get("ItemDate");
			var BarCode      = objRec.get("RepBarCode");
			
			Bar.vDeptDesc   = LocDesc;
			Bar.vNormRange  = NormRange;
			Bar.vNormObject = NormObject;
			Bar.vItemDate   = ItemDate;
			Bar.vItemDesc   = ItemDesc;
			Bar.vDeptDesc   = LocDesc;
			
			SpecimenNum = SpecimenNum*1;
			CenterNum   = CenterNum*1;
			SurroundNum = SurroundNum*1;
			for(var i = 1; i <= SpecimenNum; i++){
				//���룺8λ������+2λ�걾����
				var SubBarCode = '00' + i;
				SubBarCode = SubBarCode.substring(SubBarCode.length-2,SubBarCode.length);
				Bar.vBarCode = BarCode + SubBarCode;   //
				
				//��Ŀ���ƣ�������ġ��ܱ߼����
				var SubItemNo = i;
				var SubItemDesc = '';
				if ((CenterNum>0)&&(i<=CenterNum)){
					SubItemDesc = "����-" + SubItemNo;
				} else if ((SurroundNum>0)&&(i<=(SurroundNum+CenterNum))){
					SubItemDesc = "�ܱ�-" + SubItemNo;
				} else if ((CenterNum>0)||(SurroundNum>0)) {
					SubItemDesc = "����-" + SubItemNo;
				} else {
					SubItemDesc = "���-" + SubItemNo;
				}
				
				Bar.vItemDate   = ItemDate + '[' + SubItemDesc + '/' + SpecimenNum + ']';
				
				//�����ӡ���
				Bar.PrintOut();
			}
		}
	}
	
	obj.RowExpander_expand = function(){
		var objRec = arguments[1];
		var ReportID = objRec.get("ReportID");
		if (!ReportID) return;
		var ArgBarCode = objRec.get("ArgBarCode");
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.Rep.EnviHyRepSrv',
				QueryName : 'QryBarCodeStatus',
				Arg1 : ReportID,
				Arg2 : ArgBarCode,
				ArgCnt : 2
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var arryData = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					arryData[arryData.length] = objItem;
				}
				obj.RowTemplate.overwrite("divBarCodeDtl-" + ReportID, arryData);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divBarCodeDtl-" + ReportID);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	obj.mnuPrintReport_click = function() {
		if (obj.gridEnviHyReport.getSelectionModel().getCount() == 0) return;
		var objRec = obj.gridEnviHyReport.getSelectionModel().getSelected();
		var ReportID=objRec.get("ReportID");
		PrintReport(ReportID);
	};
	obj.mnuResult_click = function() {
		if (obj.gridEnviHyReport.getSelectionModel().getCount() == 0) return;
		var objRec = obj.gridEnviHyReport.getSelectionModel().getSelected();
		var ReportID=objRec.get("ReportID");
		InputEnviHyRst(ReportID,1);
	};
	obj.mnuReceive_click = function() {
		if (obj.gridEnviHyReport.getSelectionModel().getCount() == 0) return;
		var objRec = obj.gridEnviHyReport.getSelectionModel().getSelected();
		var ReportID=objRec.get("ReportID");
		var inputStr = ReportID;
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + 3;
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		
		var flg = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","SetResultIsNorm",inputStr,CHR_1);
		if (parseInt(flg)<=0) {
		ExtTool.alert("��ʾ","��������ʧ��!Error=" + flg);
			return false;
		}
		Common_LoadCurrPage("gridEnviHyReport");
	};
	obj.gridEnviHyReport_rowcontextmenu = function(grid,rowIndex,e) {
		grid.getSelectionModel().clearSelections();
		grid.getSelectionModel().selectRow(rowIndex,true);
		var objRec = grid.getSelectionModel().getSelected();
		//��ӡ����
		var RepResults=objRec.get("Result"); //fix bug by pylian 2015-04-27
		if (RepResults==""){
			Ext.getCmp("mnuPrintReport").disable();
		} else {
			Ext.getCmp("mnuPrintReport").enable();
		}
		//���ձ걾
		var RepStatusCode=objRec.get("RepStatusCode");
		if ((RepStatusCode!="2")&&(RepStatusCode!="3")){
			Ext.getCmp("mnuReceive").disable();
		} else {
			Ext.getCmp("mnuReceive").enable();
		}
		//¼����
		var RepStatusCode=objRec.get("RepStatusCode");
		if ((RepStatusCode!="3")&&(RepStatusCode!="4")){
			Ext.getCmp("mnuResult").disable();
		} else {
			Ext.getCmp("mnuResult").enable();
		}
        obj.mnuMenu.showAt(e.getXY());
        e.stopEvent();
	};
	
    obj.cboSSHosp_expand=function(){
	    obj.cboSurveryLoc.setValue('');
	}
	obj.cboSSHosp_Select=function(){
	    obj.cboSurveryLoc.getStore().load({}); 
	}
	
	obj.cbBar_change = function(){
		var chkBarOper = obj.cbBar.getValue().inputValue;
		if (chkBarOper == '3'){
			obj.DisplayEditResultPn(1);
		} else {
			obj.DisplayEditResultPn(0);
		}
		if (chkBarOper == '1'){
			Common_SetDisabled('btnMDBat',0);
		} else {
			Common_SetDisabled('btnMDBat',1);
		}
		if (chkBarOper == '2'){
			Common_SetDisabled('btnRstBat',0);
		} else {
			Common_SetDisabled('btnRstBat',1);
		}
		Common_SetValue('cboLoc','','');
		Common_SetValue('txtAreaBar','');
		obj.gridEnviHyReportStore.removeAll();
	};
	
	obj.DisplayBtnRstBatPn = function(flag){
		if (flag){
			document.all['btnRstBat'].style.display = 'block';
		}else{
			document.all['btnRstBat'].style.display = 'none';
		}
	}
	
	obj.DisplayBtnMDBatPn = function(flag){
		if (flag){
			document.all['btnMDBat'].style.display = 'block';
		}else{
			document.all['btnMDBat'].style.display = 'none';
		}
	}
	
	obj.DisplayEditResultPn = function(flag){
		if (flag){
			document.all['txtEnviHyPathogenPn'].style.display = 'block';
			document.all['txtEnviHyResultPn'].style.display = 'block';
		}else{
			document.all['txtEnviHyPathogenPn'].style.display = 'none';
			document.all['txtEnviHyResultPn'].style.display = 'none';
		}
	}
	
	obj.txtEnviHyResult_keydown = function(field,e){
		if (e.keyCode!=13){
			return;
		}
		obj.txtEnviHyPathogen.focus(true,true);
	}
	obj.txtEnviHyPathogen_keydown = function(field,e){
		if (e.keyCode!=13){
			return;
		}
		obj.txtAreaBar.focus(true,true);
	}
	obj.txtAreaBar_keydown = function(field,e){
		if (e.keyCode!=13){
			return;
		}
		
		var BarCode = obj.txtAreaBar.getValue();
		BarCode = BarCode.trim();
		if (BarCode==""){
			obj.txtAreaBar.focus(true,true);
			return;
		}
		
		var chkBarOper = obj.cbBar.getValue().inputValue;
		if (chkBarOper == '0'){
			obj.gridEnviHyReport_LoadByBarCode();
		} else {
			if (obj.gridEnviHyReportStore.getCount()>0) {
				var tIndex = obj.gridEnviHyReportStore.findExact("ArgBarCode",BarCode);
				if (tIndex > -1) {
					if (chkBarOper == '1') {   //���Ϸ���
						var inputStr = BarCode;
						inputStr = inputStr + CHR_1 + "2";
						inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
						inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
						
						var  flg = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","ReceiveSpecimen",inputStr,CHR_1);
						if (parseInt(flg)<1) {
							var arrFlg = flg.split('^');
							ExtTool.alert("������ʾ",arrFlg[1]);
							return;
						} else {
							obj.gridEnviHyReport_LoadByBarCode();
							Common_SetValue('txtAreaBar','');
						}
					} else if (chkBarOper == '2') {    //�걾����
						var inputStr = BarCode;
						inputStr = inputStr + CHR_1 + "3";
						inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
						inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
						
						var  flg = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","ReceiveSpecimen",inputStr,CHR_1);
						if (parseInt(flg)<1) {
							var arrFlg = flg.split('^');
							ExtTool.alert("������ʾ",arrFlg[1]);
							return;
						} else {
							obj.gridEnviHyReport_LoadByBarCode();
							Common_SetValue('txtAreaBar','');
						}
					} else if (chkBarOper == '3') {    //¼����
						var Results = Common_GetValue('txtEnviHyResult');
						var Pathogens = Common_GetValue('txtEnviHyPathogen');
						if (Results == ''){
							ExtTool.alert("��ʾ","��������������²���!");
							return;
						} else {
							var inputStr = "";
							inputStr = inputStr + CHR_1 + 4;
							inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
							inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
							inputStr = inputStr + CHR_1 + Results;
							inputStr = inputStr + CHR_1 + Pathogens;
							
							var  flg = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","InputEnviHyResult",inputStr,CHR_1 + ',' + CHR_2,BarCode);
							if (parseInt(flg)<1) {
								ExtTool.alert("������ʾ","¼��������!");
								return;
							} else {
								obj.gridEnviHyReport_LoadByBarCode();
								//��ս��¼�������
								Common_SetValue('txtEnviHyResult','');
								Common_SetValue('txtEnviHyPathogen','');
								Common_SetValue('txtAreaBar','');
							}
						}
					} else {
						//�������
					}
				} else {
					obj.gridEnviHyReport_LoadByBarCode();
					Common_SetValue('txtEnviHyResult','');
					Common_SetValue('txtEnviHyPathogen','');
					Common_SetValue('txtAreaBar','');
				}
			} else {
				obj.gridEnviHyReport_LoadByBarCode();
				Common_SetValue('txtEnviHyResult','');
				Common_SetValue('txtEnviHyPathogen','');
				Common_SetValue('txtAreaBar','');
			}
		}
	}
	
	obj.gridEnviHyReport_LoadByDateLoc = function() {
		Common_SetValue('txtAreaBar','');
		obj.gridEnviHyReportStore.removeAll();
		obj.gridEnviHyReportStore.load({params : {start : 0,limit : 50}});
	}
	
	obj.gridEnviHyReport_LoadByBarCode = function() {
		Common_SetValue('cboLoc','','');
		obj.gridEnviHyReportStore.removeAll();
		obj.gridEnviHyReportStore.load({
			params : {start : 0,limit : 50},
			callback : function(r,options,success){
				if(success){
					if (r.length>0) {
						obj.RowExpander.expandRow(0);
						var chkBarOper = obj.cbBar.getValue().inputValue;
						if (chkBarOper == '3'){
							obj.txtEnviHyResult.focus(true,true);
						} else {
							obj.txtAreaBar.focus(true,true);
						}
					} else {
						obj.txtAreaBar.focus(true,true);
					}
				}
			}
		});
	}
	
    obj.ViewEnviHyReport = function(ReportID){
		InputEnviHyRst(ReportID,0);
	}
	
	//���Ϸ������ݼ���ģ��
	obj.MaterialBillsTemplate = new Ext.XTemplate(
		'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
			'<tpl for=".">',
				'<tr><td colspan="7" align="center" style="border-bottom:1px #58D3F7 solid;font-family:times;color:red;font-size:20px;"><b>���ң�{LocDesc}</b></td></tr>',
				'<tr style="font-size:12px;height:22px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">���</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="25%">��Ŀ</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">����</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">�걾</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="20%">��Χ</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">�ѷ�/����</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="15%">���Ϸ���</td>',
				'</tr>',
				'<tbody>',
					'<tpl for="ItemData">',
						'<tpl for="NormData">',
							'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
								'<td align="center">{[xindex]}</td>',
								'<td align="left">{ItemDesc}</td>',
								'<td align="center">{ItemCategDesc}</td>',
								'<td align="center">{SpecimenNum}</td>',
								'<td align="left">{NormRange}</td>',
								'<td align="center">{IssueSpecNum}/{AddSpecNum}</td>',
								'<tpl if="UnissueSpecNum!=0">',
									'<td align="center"><input type="button" value="����" onclick="objScreen.BtnFFSpecClick(\'{ReportID}\',\'\')" id="btnFF-R{ReportID}" /></td>',
								'</tpl>',
								'<tpl if="UnissueSpecNum==0">',
									'<td align="center">',
										'<input type="text" onkeyup="value=value.replace(/[^\\\\d]/g,\'\')"  size="5" maxlength="3" id="txtBF-R{ReportID}" />&nbsp;&nbsp;',
										'<input type="button" value="����" onclick="objScreen.BtnBFSpecClick(\'{ReportID}\',\'{AddSpecNum}\')" id="btnBF-R{ReportID}" />',
									'</td>',
								'</tpl>',
							'</tr>',
						'</tpl>',
						'<tr>',
							'<td align="center"></td>',
							'<td align="center">�ϼƣ�</td>',
							'<td align="center">{ItemDesc}</td>',
							'<td align="center">{SpecCount}</td>',
							'<td align="center"></td>',
							'<td align="center">{IssueCount}/{ReissueCount}</td>',
							'<tpl if="UnissueCount!=0">',
								'<td align="center"><input type="button" value="ȫ������" onclick="objScreen.BtnFFSpecClick(\'\',\'{LocID}\',\'{ItemID}\')" id="btnFF-L{LocID}-{ItemID}" /></td>',
							'</tpl>',
							'<tpl if="UnissueCount==0">',
								'<td align="center"></td>',
							'</tpl>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</tpl>',
		'</table>'
	);
	
	obj.LoadMaterialBills = function(){
		obj.MaterialBills.LocIndex = new Array();
		obj.MaterialBills.LocData = new Array();
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.Rep.EnviHyRepSrv',
				QueryName : 'QryEnviHyRep',
				Arg1 : obj.EnviHyRepQueryArg1,
				Arg2 : obj.EnviHyRepQueryArg2,
				Arg3 : obj.EnviHyRepQueryArg3,
				Arg4 : obj.EnviHyRepQueryArg4,
				Arg5 : obj.EnviHyRepQueryArg5,
				ArgCnt : 5
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (!objItem) continue;
					var LocID = objItem.AskForLocID;
					if (!LocID) continue;
					var LocDesc = objItem.AskForLocDesc;
					if (!LocDesc) continue;
					var ItemID = objItem.ItemCategID;     //���շ������
					if (!ItemID) continue;
					var ItemDesc = objItem.ItemCategDesc;
					if (!ItemDesc) continue;
					
					var SpecCount = (objItem.SpecimenNum)*1;
					var IssueCount = (objItem.IssueSpecNum)*1;
					var UnissueCount = SpecCount - IssueCount;
					var ReissueCount = (objItem.AddSpecNum)*1;
					
					if (typeof(obj.MaterialBills.LocIndex[LocID]) != 'undefined') {
						var ind = obj.MaterialBills.LocIndex[LocID];
						var objLocX = obj.MaterialBills.LocData[ind];
					} else {
						var objLocX = {
							LocID : LocID,
							LocDesc : LocDesc,
							ItemIndex : new Array(),
							ItemData : new Array()
						};
						var ind = obj.MaterialBills.LocData.length;
						obj.MaterialBills.LocData[ind] = objLocX;
						obj.MaterialBills.LocIndex[LocID] = ind;
					}
					
					if (typeof(objLocX.ItemIndex[ItemID]) != 'undefined') {
						var ind = objLocX.ItemIndex[ItemID];
						var objItemX = objLocX.ItemData[ind];
					} else {
						var objItemX = {
							ItemID : ItemID,
							ItemDesc : ItemDesc,
							LocID : LocID,
							LocDesc : LocDesc,
							SpecCount : 0,
							IssueCount : 0,    //��������
							UnissueCount : 0,  //δ������
							ReissueCount : 0,  //��������
							NormData : new Array()
						};
						var ind = objLocX.ItemData.length;
						objLocX.ItemData[ind] = objItemX;
						objLocX.ItemIndex[ItemID] = ind;
					}
					
					var ind = objItemX.NormData.length;
					objItemX.NormData[ind] = objItem;
					objItemX.SpecCount = objItemX.SpecCount + SpecCount;
					objItemX.IssueCount = objItemX.IssueCount + IssueCount;
					objItemX.UnissueCount = objItemX.UnissueCount + UnissueCount;
					objItemX.ReissueCount = objItemX.ReissueCount + ReissueCount;
					
					var ind = objLocX.ItemIndex[ItemID];
					objLocX.ItemData[ind] = objItemX;
					var ind = obj.MaterialBills.LocIndex[LocID];
					obj.MaterialBills.LocData[ind] = objLocX;
				}
				obj.MaterialBillsTemplate.overwrite("divMaterialBills",obj.MaterialBills.LocData);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divMaterialBills");
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	obj.btnMDBat_click = function() {
		if (obj.gridEnviHyReportStore.getCount()<1){
			ExtTool.alert("��ʾ","���Ȳ�ѯ�������뵥!");
			return;
		}
		
		var winMaterialBills = Ext.getCmp('winMaterialBills');
		if (!winMaterialBills) {
			winMaterialBills = new Ext.Window({
				id : 'winMaterialBills',
				height : 450,
				width : 750,
				closable : false,
				modal : true,
				layout : 'fit',
				resizable : false,
				title : '��������ѧ���-���Ϸ���',
				items: [
					new Ext.Panel({
						id : 'MainPanel'
						,region : 'center'
						,autoScroll : true
						,html : '<div id="divMaterialBills"></div>'
					})
				]
				,bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "winMaterialBills_btnCancel",
						iconCls : 'icon-close',
						width : 70,
						text : "�ر�",
						listeners : {
							'click' : function(){
								winMaterialBills.close();
							}
						}
					})
				]
				,listeners :{
					"beforeclose" : function(){
						//ˢ�¸�ҳ��
					},
					"beforeshow" : function(){
						//����ҳ������
						obj.LoadMaterialBills();
					}
				}
			});
		}
		winMaterialBills.show();
	}
	
	obj.BtnBFSpecClick = function(RepID,ReissueNum){
		var txtReissueNum = document.getElementById('txtBF-R' + RepID).value;
		if (txtReissueNum == '') txtReissueNum = 1;
		var ReissueNum = (txtReissueNum*1) + (ReissueNum*1);
		
		var inputStr = RepID;
		inputStr = inputStr + CHR_1 + ReissueNum;
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		
		var flg = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","SetAddSpecimenNum",inputStr,CHR_1);
		
		obj.LoadMaterialBills();
		Common_LoadCurrPage("gridEnviHyReport");
	}
	
	obj.BtnFFSpecClick = function(RepID,LocID,ItemID){
		var arrReport = new Array();
		if (RepID != ''){
			arrReport.push(RepID);
		} else if (LocID != ''){
			var ind = obj.MaterialBills.LocIndex[LocID];
			var objLocX = obj.MaterialBills.LocData[ind];
			if (objLocX){
				var ind = objLocX.ItemIndex[ItemID];
				var objItemX = objLocX.ItemData[ind];
				if (objItemX){
					var arrNorm = objItemX.NormData;
					for (var ind = 0; ind < arrNorm.length; ind++){
						var objRec = arrNorm[ind];
						if (!objRec) continue;
						if (objRec.RepStatusCode != '1') continue;  //ֻ��������״̬����
						arrReport.push(objRec.ReportID);
					}
				}
			}
		}
		
		for (var ind = 0; ind < arrReport.length; ind++){
			var ReportID = arrReport[ind];
			if (!ReportID) continue;
			
			var inputStr = ReportID;
			inputStr = inputStr + CHR_1 + '';
			inputStr = inputStr + CHR_1 + '';
			inputStr = inputStr + CHR_1 + 2;
			inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
			inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
			var  flg = ExtTool.RunServerMethod("DHCMed.NINF.Rep.EnviHyReport","SetResultIsNorm",inputStr,CHR_1);
		}
		
		obj.LoadMaterialBills();
		Common_LoadCurrPage("gridEnviHyReport");
		Ext.getCmp('winMaterialBills').close();
	}
	
	obj.MDEditer = function(objRec,locNum,itemNum,htmlStr) {
		WinHeight = 70+locNum*120+itemNum*30
		if(WinHeight>500){
			WinHeight = 500
		}
		var winMDEditer = Ext.getCmp('MDEditer');
		if (!winMDEditer)
		{
			winMDEditer = new Ext.Window({
				id : 'MDEditer',
				height : WinHeight,
				width :530, 
				closeAction: 'close',
				modal : true,
				title : '���Ϸ���',
				layout : 'fit',
				resizable : false,
				items: [
					{
						layout : 'form',
						labelAlign : 'center',
						labelWidth : 70,
						autoScroll : true,
						frame : true,
						html:htmlStr
					}
				],bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "grid_btnCancel",
						iconCls : 'icon-close',
						width : 60,
						text : "�ر�",
						listeners : {
							'click' : function(){
								winMDEditer.close();
							}
						}
					})
				]
			});
		}
		winMDEditer.show();
	}
}

function WindowRefresh_Handler()
{
	Common_LoadCurrPage("gridEnviHyReport");
	var objCmp = Ext.getCmp('txtAreaBar');
	if (objCmp){
		objCmp.setValue();
		objCmp.focus(true,true);
	}
}
								
