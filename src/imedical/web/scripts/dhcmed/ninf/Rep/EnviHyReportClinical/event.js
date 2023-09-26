function InitViewport1Event(obj) {
	obj.RecRowID = "";
	obj.ClsRepEnviHyReport = ExtTool.StaticServerObject("DHCMed.NINF.Rep.EnviHyReport");
	obj.ClsRepEnviHyReportSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.EnviHyReport");
	obj.ClsDicEnviHyItmMapSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.EnviHyItmMap");
	obj.ClsCommonClsSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Srv.CommonSrv");
	obj.CtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
		
	obj.LoadEvent = function(args)
    {
	/*	var objLoc = obj.CtlocSrv.GetObjById(session['LOGON.CTLOCID']);
		Common_SetValue("cboLoc",objLoc.Rowid,objLoc.Descs);
		obj.cboLoc.setDisabled("true");
	*/	
		if (obj.AdminPower != '1') {
			obj.cboLoc.setDisabled(true);
			var LogLocID = session['LOGON.CTLOCID'];
			var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
			var objLoc = objCtlocSrv.GetObjById(LogLocID);
			if (objLoc) {
				obj.cboLoc.setValue(objLoc.Rowid);
				obj.cboLoc.setRawValue(objLoc.Descs);
			}
		}
		
		obj.gridEnviHyReportStore.load({params : {start : 0,limit : 50}});
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnAdd.on("click",obj.btnAdd_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnCopy.on("click",obj.btnCopy_click,obj);
		obj.gridEnviHyReport.on("rowdblclick",obj.gridEnviHyReport_rowdblclick,obj);
		//obj.grid_RowEditer_cboNorms.on("select",obj.grid_RowEditer_cboNorms_select,obj);
		obj.grid_RowEditer_txtItem.on("select",obj.grid_RowEditer_txtItem_select,obj);
		obj.btnPBC.on("click",obj.btnPBC_click,obj);
		

  	};
	obj.btnPBC_click = function (){
		var arrList = obj.sm.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("��ʾ", "��ѡ�м�¼�����ܴ�ӡ!");
			return;
		}
		for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
			var r = arrList[rowIndex];
			var BarCode=r.get("EHRBarCode");

			var Bar;
			Bar = new ActiveXObject("DHCMedBarCode.PrintBarEH");
			Bar.PrinterName = "pdfFactory";  //��ӡ������
			Bar.SetPrinter();  //���ô�ӡ��
			Bar.vDeptDesc = '����ҽ���һ��';
			Bar.vItemDesc = '��������';
			Bar.vBarCode = "S"+BarCode ;
			Bar.vBarFormat = "1";
			Bar.PrintOut();
			/*var objApp = new ActiveXObject("Word.Application");
			var TemplatePath = obj.ClsCommonClsSrv.GetTemplatePath();
			var filePath = TemplatePath + "a.dot";
			objApp.Documents.Open(filePath); 
			var objDoc = objApp.ActiveDocument;
			objDoc.Bookmarks("Title").Range.Text = "Ҫ��ӡ�ı���";
            objDoc.Bookmarks("Content").Range.Text = BarCode;  
			objApp.Application.Visible=false; 
			//objDoc.saveAs("c:\PrinterTemp.doc"); //������ʱ�ļ�word  
			objApp.ActiveDocument.PrintOut();	
			objApp.Quit();*/
		}
	}
	obj.grid_RowEditer_txtItem_select = function(){
		obj.grid_RowEditer_cboNorms.getStore().load({});
		Common_SetValue("grid_RowEditer_cboNorms",'');
	}
	obj.btnQuery_click = function() {
		obj.gridEnviHyReportStore.load({params : {start : 0,limit : 50}});
	}
	obj.btnDelete_click =function(){
		var arrList = obj.sm.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("��ʾ", "��ѡ�м�¼������ɾ��!");
			return;
		}
		Ext.MessageBox.confirm('��ʾ', 'ȷ��ɾ����', function(btn){
			var str = new Array()
			if (btn=="yes") {
				for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
					var r = arrList[rowIndex];
					var ReportID=r.get("ReportID");
					var RepStatus=r.get("RepStatusDesc");
					if(RepStatus=="����"){
						var flag = obj.ClsRepEnviHyReport.DeleteById(ReportID)
						if(flag<=0){
							//���������ǲ��ᷢ����
							str[rowIndex] = "ѡ�����ݵ�"+(rowIndex+1)+"��ɾ��ʧ�ܣ�<br/>"
						}
					}else{
						str[rowIndex] = "ѡ�����ݵ�"+(rowIndex+1)+"��Ϊ������״̬������ɾ����<br/>"
					}
				}
				if(str.length>0){
					ExtTool.alert("��ʾ", str.join(""));
				}
				obj.gridEnviHyReportStore.load({params : {start : 0,limit : 50}});
			}
		});
	}
	obj.gridEnviHyReport_rowdblclick = function() {
		var rowIndex = arguments[1];
		var objRec = obj.gridEnviHyReport.getStore().getAt(rowIndex);
		if(objRec.get('RepStatusDesc')!="����"){
			return
		}
		obj.grid_RowEditer(objRec,1);
	}
	obj.btnAdd_click = function() {
		obj.grid_RowEditer('',1);
	}
	obj.btnCopy_click = function(){
		var theDate = new Date().dateFormat('Y-m');
		var selectDate = Common_GetValue('txtDate');
		if(selectDate==theDate){
			ExtTool.alert("��ʾ","���ڵ�ǰ�£����ѯ��ǰ���·������ٽ��и��ƣ�");
			return;
		}
		var arrList = obj.sm.getSelections();
		if (arrList.length < 1) {
			ExtTool.alert("��ʾ", "��ѡ�м�¼�����ܸ���!");
			return;
		}
		Ext.MessageBox.confirm('��ʾ', 'ȷ�����ƣ�', function(btn){
			var str = new Array()
			if (btn=="yes") {
				for (var rowIndex=0;rowIndex<arrList.length;rowIndex++){
					var r = arrList[rowIndex];
					var LocID = Common_GetValue('cboLoc');
					var normID = r.get("NormID");
					var ItemObj = r.get("ItemObj");
					var DetectDate = new Date().dateFormat('Y-m-d');
					var SpecimenType = r.get("SpecimenTypeID");
					var SpecimenNum = r.get("SpecimenNum");
					var Resume = r.get("RepResume");
					var ReportID = '';
					var inputStr = ReportID;
					inputStr = inputStr + CHR_1 + LocID;
					inputStr = inputStr + CHR_1 + '';
					inputStr = inputStr + CHR_1 + normID;
					inputStr = inputStr + CHR_1 + ItemObj;
					inputStr = inputStr + CHR_1 + DetectDate;
					inputStr = inputStr + CHR_1 + SpecimenType;
					inputStr = inputStr + CHR_1 + SpecimenNum;
					inputStr = inputStr + CHR_1 + '';
					inputStr = inputStr + CHR_1 + '';
					inputStr = inputStr + CHR_1 + '';
					inputStr = inputStr + CHR_1 + '';
					inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'] ;
					inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
					inputStr = inputStr + CHR_1 + 1;
					inputStr = inputStr + CHR_1 + Resume;
					inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'] + CHR_2 + session['LOGON.USERID'];
					var  flg = obj.ClsRepEnviHyReportSrv.SaveRepRec(inputStr,CHR_1 + "," + CHR_2);
					if (parseInt(flg)<=0) {
						str[rowIndex] = "ѡ�����ݵ�"+(rowIndex+1)+"������ʧ�ܣ�<br/>"
					}
				}
				if(str.length>0){
					ExtTool.alert("��ʾ", str.join(""));
				}else{
					Common_SetValue("txtDate",theDate);
					obj.gridEnviHyReportStore.load({params : {start : 0,limit : 50}});
				}
			}
		});
	}

	obj.grid_RowEditer_cboNorms_select = function(combo,record,index) {
		var objItem = obj.ClsDicEnviHyItmMapSrv.getObjItem(combo.getValue())
		if(objItem!=0){
			obj.grid_RowEditer_txtItem.setValue(objItem.EHIDesc);
		}else{
			alert("��Ŀû���׼������")
		}
	}
	
	obj.grid_RowEditer = function(objRec,ArgStat) {
		obj.stat = ArgStat
		obj.grid_RowEditer_objRec = objRec;
		var winGridRowEditer = Ext.getCmp('grid_RowEditer');
		if (!winGridRowEditer)
		{
			winGridRowEditer = new Ext.Window({
				id : 'grid_RowEditer',
				height : 305,
				width :360, 
				closeAction: 'hide',
				modal : true,
				title : '��������ѧ���-�༭',
				layout : 'fit',
				resizable : false,
				items: [
					{
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 70,
						autoScroll : true,
						frame : true,
						items : [
							{  //�����Ŀ
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 70,
								width:250,
								items: obj.grid_RowEditer_txtItem
							} ,
							{ //��ⷶΧ
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 70,
								width:250,
								items:obj.grid_RowEditer_cboNorms
							}
							
							,{ //��Ŀ����
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 70,
								width:320,
								items: obj.grid_RowEditer_txtItemObj
							} 
							,{ //�������
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 70,
								width:250,
								items:obj.grid_RowEditer_txtDate
							} ,{ //�������
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 70,
								width:250,
								items:obj.grid_RowEditer_cboSpecimenType 
							} ,{ //�������
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 70,
								width:250,
								items:obj.grid_RowEditer_txtSpecimenNum
							} 
							,{ //��ע
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 70,
								width:320,
								items:obj.grid_RowEditer_txtResume
							}
						]
					}
				],bbar : [
					'->',
					new Ext.Toolbar.Button({
						id: "grid_RowEditer_btnUpdate",
						iconCls : 'icon-update',
						width : 60,
						text : "����",
						listeners : {
							'click' : function(){
								var LocID = Common_GetValue('cboLoc');
								var normID = Common_GetValue('grid_RowEditer_cboNorms');
								var ItemDesc = Common_GetValue('grid_RowEditer_txtItem');
								var ItemObj = Common_GetValue('grid_RowEditer_txtItemObj');
								var DetectDate = Common_GetValue('grid_RowEditer_txtDate');
								var SpecimenType = Common_GetValue('grid_RowEditer_cboSpecimenType');
								var SpecimenNum = Common_GetValue('grid_RowEditer_txtSpecimenNum');
								var Resume = Common_GetValue('grid_RowEditer_txtResume');
								var errInfo = '';
								if (normID == '') {
									errInfo = errInfo + '��ⷶΧΪ��!<br>'
								}
								if (ItemDesc == '') {
									errInfo = errInfo + '�����ĿΪ��!<br>'
								}
								if (ItemObj == '') {
									errInfo = errInfo + '��Ŀ����Ϊ��!<br>'
								}
								if (DetectDate == '') {
									errInfo = errInfo + '�������Ϊ��!<br>'
								}
								if (SpecimenType == '') {
									errInfo = errInfo + '�걾����Ϊ��!<br>'
								}
								if (SpecimenNum == '') {
									errInfo = errInfo + '�걾����Ϊ��!<br>'
								}
								if (errInfo != '') {
									ExtTool.alert("��ʾ",errInfo);
									return;
								}
								var ReportID = '';
								var objRec = obj.grid_RowEditer_objRec;
								if (objRec) {
									ReportID = objRec.get('ReportID');
								}
							/*	var inputStr = ReportID;
								inputStr = inputStr + CHR_1 + LocID;
								inputStr = inputStr + CHR_1 + '';
								inputStr = inputStr + CHR_1 + normID;
								inputStr = inputStr + CHR_1 + ItemObj;
								inputStr = inputStr + CHR_1 + DetectDate;
								inputStr = inputStr + CHR_1 + SpecimenType;
								inputStr = inputStr + CHR_1 + SpecimenNum;
								inputStr = inputStr + CHR_1 + '';
								inputStr = inputStr + CHR_1 + '';
								inputStr = inputStr + CHR_1 + '';
								inputStr = inputStr + CHR_1 + '';
								inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'] ;
								inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
								inputStr = inputStr + CHR_1 + obj.stat;
								inputStr = inputStr + CHR_1 + Resume;
								inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'] + CHR_2 + session['LOGON.USERID'];			
							*/	
								/*-----add by yanjifu 20140409-----*/
								var inputStr = ReportID;								//����ID
								inputStr = inputStr + CHR_1 + LocID;					//����ID
								inputStr = inputStr + CHR_1 + ItemDesc;					//�����Ŀ
								inputStr = inputStr + CHR_1 + normID;					//��ⷶΧID
								inputStr = inputStr + CHR_1 + ItemObj;					//��Ŀ����
								inputStr = inputStr + CHR_1 + DetectDate;				//�������
								inputStr = inputStr + CHR_1 + SpecimenType;				//�걾����
								inputStr = inputStr + CHR_1 + SpecimenNum;				//�걾����
								inputStr = inputStr + CHR_1 + Resume;					//��ע
							//	inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];	//��½����ID
							//	inputStr = inputStr + CHR_1 + session['LOGON.USERID'];	//��½�û�ID
								inputStr = inputStr + CHR_1 + obj.stat;					//
								inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'] + CHR_2 + session['LOGON.USERID'];								 //��½����ID+�ָ���2+��½�û�ID
								var  flg = obj.ClsRepEnviHyReportSrv.SaveRepRec(inputStr,CHR_1 + "," + CHR_2);
								if (parseInt(flg)<=0) {
									ExtTool.alert("��ʾ","��������ʧ��!Error=" + flg);
									return false;
								}
								Common_LoadCurrPage("gridEnviHyReport");
								winGridRowEditer.hide();
							}
						}
					}),
					new Ext.Toolbar.Button({
						id: "grid_RowEditer_btnCancel",
						iconCls : 'icon-exit',
						width : 60,
						text : "�ر�",
						listeners : {
							'click' : function(){
								winGridRowEditer.hide();
							}
						}
					})
				],
				listeners :{
					'beforeshow' : function(){
						objRec = obj.grid_RowEditer_objRec
						if(objRec){
							Common_SetValue("grid_RowEditer_cboNorms",objRec.get("NormID"),objRec.get("NormRange"));
							Common_SetValue("grid_RowEditer_txtItem",objRec.get("ItemDesc"));
							Common_SetValue("grid_RowEditer_txtItemObj",objRec.get("ItemObj"));
							Common_SetValue("grid_RowEditer_txtDate",objRec.get("EHRDate"));
							Common_SetValue("grid_RowEditer_cboSpecimenType",objRec.get("SpecimenTypeID"),objRec.get("SpecimenTypeDesc"));
							Common_SetValue("grid_RowEditer_txtSpecimenNum",objRec.get("SpecimenNum"));
							Common_SetValue("grid_RowEditer_txtResume",objRec.get("RepResume"));
						}else{
							Common_SetValue("grid_RowEditer_cboNorms","");
							Common_SetValue("grid_RowEditer_txtItem","");
							Common_SetValue("grid_RowEditer_txtItemObj","");
							var currDate = new Date().dateFormat('Y-m-d');
							Common_SetValue("grid_RowEditer_txtDate",currDate);
							Common_SetValue("grid_RowEditer_cboSpecimenType","");
							Common_SetValue("grid_RowEditer_txtSpecimenNum","");
							Common_SetValue("grid_RowEditer_txtResume","");
						}
					}
				}
			});
		}
		winGridRowEditer.show();
	}
}

