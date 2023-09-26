// dhcmed.fbd.report.csp
function InitviewScreen() {
	//alert("gui:"+ReportID+":"+EpisodeID+":"+PatientID+":"+LocFlag);
	if (EpisodeID=="" || PatientID=="") {
		ExtTool.alert("��ʾ", "������Ϣ������!");
		return;
	}
	
	var obj = new Object();
	obj.reportID = ReportID;
	obj.objCurrPaadm = null;
	obj.objCurrPatient = null;
	obj.objCurrReport = null;
	obj.objCurrCtLoc = null;
	obj.objCurrUser = null;
	obj.DelListFood = "";
	obj.DelListSample = "";
	obj.currGridFoodRowID = "";
	obj.currGridSampleRowID = "";
	
	// ****************************** ������ html
	var RowHeight = 30, space = "&nbsp;&nbsp;&nbsp;";	// 1170 682
	var pnWidth = document.body.clientWidth>1170 ? document.body.clientWidth - 30 : 1140;
	
	obj.PatHTML = ''	// ���˻�����Ϣ
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'  //ȥ��rules="cols"��ֹIE11�Ǽ�������ʾ����
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right">������ң�</td>'
	 +			'<td width="17%" class="" align="left"><div id="divRepLoc"></div></td>'
	 +			'<td width="7%" class="" align="right">�����ˣ�</td>'
	 +			'<td width="17%" class="" align="left"><div id="divRepUser"></div></td>'
	 +			'<td width="7%" class="" align="right">����λ�ã�</td>'
	 +			'<td width="17%" class="" align="left"><div id="divRepPlace"></div></td>'
	 +			'<td width="7%" class="" align="right">����״̬��</td>'
	 +			'<td width="17%" class="" align="left"><div id="divRepStatus"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right">�����</td>'
	 +			'<td width="17%" class="" align="left"><div id="divOPNo"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>�Ƿ�סԺ</td>'
	 +			'<td width="17%" class="" align="left">'+space+''
	 +				'<input type="Radio" name="IsInHosp" id="IsInHosp-1" />'+space+'��'+space+''
	 +				'<input type="Radio" name="IsInHosp" id="IsInHosp-0" />'+space+'��'+space+'' // checked="checked"
	 +			'</td>'
	 +			'<td width="7%" class="" align="right">סԺ��</td>'
	 +			'<td width="17%" class="" align="left"><div id="divIPNo"></div></td>'
	 +			'<td width="7%" class="" align="right">�������</td>'
	 +			'<td width="17%" class="" align="left"><div id="divCardNo"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>����</td>'
	 +			'<td width="17%" class="" align="left"><div id="divPatName"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>�Ա�</td>'
	 +			'<td width="17%" class="" align="left"><div id="divSex"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>����</td>'
	 +			'<td width="17%" class="" align="left"><div id="divAge"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��������</td>'
	 +			'<td width="17%" class="" align="left"><div id="divBirthday"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right">���֤��</td>'
	 +			'<td width="17%" class="" align="left"><div id="divPersonalID"></div></td>'
	 +			'<td width="7%" class="" align="right">�໤������</td>'
	 +			'<td width="17%" class="" align="left"><div id="divContactor"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��ϵ��ʽ</td>'
	 +			'<td width="17%" class="" align="left"><div id="divTelephone"></div></td>'
	 +			'<td width="26%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right">���˼���</td>'
	 +			'<td width="17%" class="" align="left"><div id="divPatLevel"></div></td>'
	 +			'<td width="7%" class="" align="right">�����ܼ�</td>'
	 +			'<td width="17%" class="" align="left"><div id="divEncryptLevel"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>����ְҵ</td>'
	 +			'<td width="17%" class="" align="left"><div id="divOccupation"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��������</td>'
	 +			'<td width="17%" class="" align="left"><div id="divPatArea"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right">��λ</td>'
	 +			'<td width="41%" class="" align="left"><div id="divCompany"></div></td>'
	 +			'<td width="7%" class="" align="right">��ס��ַ</td>'
	 +			'<td width="41%" class="" align="left"><div id="divCurrAddress"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>ʡ</td>'
	 +			'<td width="17%" class="" align="left"><div id="divCurrProvince"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��</td>'
	 +			'<td width="17%" class="" align="left"><div id="divCurrCity"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��</td>'
	 +			'<td width="17%" class="" align="left"><div id="divCurrCounty"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��</td>'
	 +			'<td width="17%" class="" align="left"><div id="divCurrVillage"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>�ֵ�</td>'
	 +			'<td width="17%" class="" align="left"><div id="divCurrRoad"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��������</td>'
	 +			'<td width="17%" class="" align="left"><div id="divDisCate"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��������</td>'
	 +			'<td width="17%" class="" align="left"><div id="divDisDesc"></div></td>'
	 +			'<td width="7%" class="" align="right">������ע</td>'
	 +			'<td width="17%" class="" align="left"><div id="divDisText"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>����ʱ��</td>'
	 +			'<td width="17%" class="" align="left"><div id="divSickDate" style="float:left"></div><div id="divSickTime" style="float:left"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>����ʱ��</td>'
	 +			'<td width="17%" class="" align="left"><div id="divAdmitDate" style="float:left"></div><div id="divAdmitTime" style="float:left"></div></td>'
	 +			'<td width="7%" class="" align="right">����ʱ��</td>'
	 +			'<td width="17%" class="" align="left"><div id="divDeathDate" style="float:left"></div><div id="divDeathTime" style="float:left"></div></td>'
	 +			'<td width="7%" class="" align="right"></td>'
	 +			'<td width="17%" class="" align="left"><div></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight*2+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>�������</td>'
	 +			'<td width="41%" class="" align="left"><div id="divPreDiagnos"></div></td>'
	 +			'<td width="7%" class="" align="right">������ʷ</td>'
	 +			'<td width="41%" class="" align="left"><div id="divAnamnesis"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight*2+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	// +			'<td width="2%" class=""></td>'
	 +			'<td width="14%" class="" align="right"><font color="red">*</font>����ǰ�Ƿ�ʹ�ÿ�����</td>'
	 +			'<td width="12%" class="" align="left">'+space+''
	 +				'<input type="Radio" name="IsUseAnti" id="IsUseAnti-1" onclick=IsUseAnti_Click() />'+space+'��'+space+''
	 +				'<input type="Radio" name="IsUseAnti" id="IsUseAnti-0" onclick=IsUseAnti_Click() />'+space+'��'+space+'' // checked="checked"
	 +			'</td>'
	 +			'<td width="7%" class="" align="right">����������</td>'
	 +			'<td width="41%" class="" align="left"><div id="divUseAntiDesc"></div></td>'
	 +			'<td width="26%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'';
	
	obj.SignHTML = ''	// ��Ҫ֢״������
	 +	'<div id="divSign"></div>'
	 +	'';
	
	obj.FoodHTML = ''	// ��¶��Ϣ
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>ʳƷ����</td>'
	 +			'<td width="25%" class="" align="left"><div id="divFoodName"></div></td>'
	 +			'<td width="7%" class="" align="right">ʳƷƷ��</td>'
	 +			'<td width="25%" class="" align="left"><div id="divFoodBrand"></div></td>'
	 +			'<td width="7%" class="" align="right">��������</td>'
	 +			'<td width="25%" class="" align="left"><div id="divManufacturer"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>����ص�</td>'
	 +			'<td width="25%" class="" align="left"><div id="divWhereToBuy"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��ʳ����</td>'
	 +			'<td width="25%" class="" align="left"><div id="divEatingPlaces"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��ʳ����</td>'
	 +			'<td width="25%" class="" align="left"><div id="divEatingNum"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��ʳʱ��</td>'
	 +			'<td width="25%" class="" align="left"><div id="divEatingDate" style="float:left"></div><div id="divEatingTime" style="float:left"></div></td>'
	 +			'<td width="12%" class="" align="right"><font color="red">*</font>�������Ƿ񷢲�</td>'
	 +			'<td width="20%" class="" align="left">'+space+''
	 +				'<input type="Radio" name="IsIncidence" id="IsIncidence-1" value="��" />'+space+'��'+space+''
	 +				'<input type="Radio" name="IsIncidence" id="IsIncidence-0" value="��" />'+space+'��'+space+'' // checked="checked"
	 +			'</td>'
	 +			'<td width="12%" class="" align="right"><font color="red">*</font>�Ƿ����</td>'
	 +			'<td width="20%" class="" align="left">'+space+''
	 +				'<input type="Radio" name="IsSampling" id="IsSampling-1" value="��" />'+space+'��'+space+''
	 +				'<input type="Radio" name="IsSampling" id="IsSampling-0" value="��" />'+space+'��'+space+'' // checked="checked"
	 +			'</td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'';
	
	obj.SampleHTML = ''	// ���������ɼ�
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>�������</td>'
	 +			'<td width="25%" class="" align="left"><div id="divSampleNo"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��������</td>'
	 +			'<td width="25%" class="" align="left"><div id="divSampleType"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��������</td>'
	 +			'<td width="25%" class="" align="left"><div id="divSampleDate"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="" cellspacing="0" cellpadding="0" border="0" >'
	 +		'<tr>'
	 +			'<td width="2%" class=""></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��������</td>'
	 +			'<td width="25%" class="" align="left"><div id="divSampleNumber"></div></td>'
	 +			'<td width="7%" class="" align="right"><font color="red">*</font>��λ</td>'
	 +			'<td width="25%" class="" align="left"><div id="divSampleUnit"></div></td>'
	 +			'<td width="7%" class="" align="right">��ע</td>'
	 +			'<td width="25%" class="" align="left"><div id="divSampleResume"></div></td>'
	 +			'<td width="2%" class=""></td>'
	 +		'</tr>'
	 +	'</table>'
	 +	'';
	// ****************************** ������ html
	
	// ****************************** ������ btn report
	obj.btnSaveTmp = new Ext.Button({
		id : 'btnSaveTmp'
		,iconCls : 'icon-temp'
		,text : '�ݸ�'
	});
	
	obj.btnSaveRep = new Ext.Button({
		id : 'btnSaveRep'
		,iconCls : 'icon-save'
		,text : '����'
	});
	
	obj.btnExecheck = new Ext.Button({
		id : 'btnExecheck'
		,iconCls : 'icon-check'
		,text : '���'
	});
	
	obj.btnCancheck = new Ext.Button({
		id : 'btnCancheck'
		,iconCls : 'icon-undo '
		,text : 'ȡ�����'
	});
	
	obj.btnReturn = new Ext.Button({
		id : 'btnReturn'
		,iconCls : 'icon-cancel'
		,text : '�˻�'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete '
		,text : 'ɾ��'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,text : '��ӡ'
	});
	
	obj.btnClose = new Ext.Button({
		id : 'btnClose'
		,iconCls : 'icon-close'
		,text : '�ر�'
	});
	
	obj.btnReported = new Ext.Button({
		id : 'btnReported'
		,iconCls : 'icon-btnReported'
		,text : '��Ժ�ѱ�'
	});
	
	obj.btnSaveFood = new Ext.Button({
		id : 'btnSaveFood'
		,iconCls : 'icon-save'
		,text : '���汩¶��Ϣ'
	});
	obj.btnDeleteFood = new Ext.Button({
		id : 'btnDeleteFood'
		,iconCls : 'icon-delete'
		,text : 'ɾ����¶��Ϣ'
	});
	obj.btnSaveSample = new Ext.Button({
		id : 'btnSaveSample'
		,iconCls : 'icon-save'
		,text : '����������Ϣ'
	});
	obj.btnDeleteSample = new Ext.Button({
		id : 'btnDeleteSample'
		,iconCls : 'icon-delete'
		,text : 'ɾ��������Ϣ'
	});
	// ****************************** ������ btn report
	
	// ****************************** ������ gridPanel
	obj.gridFoodStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridFoodStore = new Ext.data.Store({
		proxy : obj.gridFoodStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},[
			{ name : 'ID', mapping : 'ID' }
			,{ name : 'FoodName', mapping : 'FoodName' }
			,{ name : 'FoodBrand', mapping : 'FoodBrand' }
			,{ name : 'Manufacturer', mapping : 'Manufacturer' }
			,{ name : 'WhereToBuy', mapping : 'WhereToBuy' }
			,{ name : 'EatingPlaces', mapping : 'EatingPlaces' }
			,{ name : 'EatingDate', mapping : 'EatingDate' }
			,{ name : 'EatingTime', mapping : 'EatingTime' }
			,{ name : 'EatingNum', mapping : 'EatingNum' }
			,{ name : 'IsIncidence', mapping : 'IsIncidence' }
			,{ name : 'IsIncidenceDesc', mapping : 'IsIncidenceDesc' }
			,{ name : 'IsSampling', mapping : 'IsSampling' }
			,{ name : 'IsSamplingDesc', mapping : 'IsSamplingDesc' }
		])
	});
	obj.gridFood = new Ext.grid.GridPanel({
		id : 'gridFood'
		,header : true
		,store : obj.gridFoodStore
		,columnLines : true
		,loadMask : true
		,region : 'center'
		,frame : true
		,height : 150
		,width : pnWidth
		,autoScroll : true
		,title : '<img SRC="../scripts/dhcmed/img/EpdInfo.png">��¶��Ϣ���Ƿ����ǽ�ʳ��ĳЩʳƷ���������֢״�����"��"�������б������дʳƷ��Ϣ������д���������ص�ͽ�ʳ����������дһ�'
		,columns : [
			new Ext.grid.RowNumberer()
			,{ header : 'ʳƷ����', width : 120, dataIndex : 'FoodName', sortable : true }
			,{ header : 'ʳƷƷ��', width : 120, dataIndex : 'FoodBrand', sortable : true }
			,{ header : '��������', width : 120, dataIndex : 'Manufacturer', sortable : true }
			,{ header : '����ص�', width : 120, dataIndex : 'WhereToBuy', sortable : true }
			,{ header : '��ʳ����', width : 120, dataIndex : 'EatingPlaces', sortable : true }
			,{ header : '��ʳ����', width : 100, dataIndex : 'EatingDate', sortable : true }
			,{ header : '��ʳʱ��', width : 100, dataIndex : 'EatingTime', sortable : true }
			,{ header : '��ʳ����', width : 80, dataIndex : 'EatingNum', sortable : true }
			,{ header : '�������Ƿ񷢲�', width : 100, dataIndex : 'IsIncidenceDesc', sortable : true }
			,{ header : '�Ƿ����', width : 100, dataIndex : 'IsSamplingDesc', sortable : true }
		]
	});
	obj.gridFoodStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.FBDService.ReportSrv';
		param.QueryName = 'QryReportFood';
		param.Arg1 = obj.reportID;
		param.ArgCnt = 1;
	});
	// ******************************
	obj.gridSampleStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridSampleStore = new Ext.data.Store({
		proxy : obj.gridSampleStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},[
			{ name : 'ID', mapping : 'ID' }
			,{ name : 'SampleNo', mapping : 'SampleNo' }
			,{ name : 'SampleTypeID', mapping : 'SampleTypeID' }
			,{ name : 'SampleTypeDesc', mapping : 'SampleTypeDesc' }
			,{ name : 'SampleNumber', mapping : 'SampleNumber' }
			,{ name : 'SampleUnitID', mapping : 'SampleUnitID' }
			,{ name : 'SampleUnitDesc', mapping : 'SampleUnitDesc' }
			,{ name : 'SampleDate', mapping : 'SampleDate' }
			,{ name : 'Resume', mapping : 'Resume' }
		])
	});
	obj.gridSample = new Ext.grid.GridPanel({
		id : 'gridSample'
		,header : true
		,store : obj.gridSampleStore
		,columnLines : true
		,loadMask : true
		,region : 'center'
		,frame : true
		,height : 150
		,width : pnWidth
		,autoScroll : true
		,title : '<img SRC="../scripts/dhcmed/img/EpdInfo.png">���������ɼ����Ƿ�ɼ�����걾�����"��"���ڱ������д�걾��Ϣ��'
		,columns : [
			new Ext.grid.RowNumberer()
			,{ header : '�������', width : 160, dataIndex : 'SampleNo', sortable : true }
			,{ header : '��������', width : 160, dataIndex : 'SampleTypeDesc', sortable : true }
			,{ header : '��������', width : 160, dataIndex : 'SampleNumber', sortable : true }
			,{ header : '��λ', width : 160, dataIndex : 'SampleUnitDesc', sortable : true }
			,{ header : '��������', width : 160, dataIndex : 'SampleDate', sortable : true }
			,{ header : '��ע', width : 280, dataIndex : 'Resume', sortable : true }
		]
	});
	obj.gridSampleStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.FBDService.ReportSrv';
		param.QueryName = 'QryReportSample';
		param.Arg1 = obj.reportID;
		param.ArgCnt = 1;
	});
	// ****************************** ������ gridPanel
	
	// ****************************** ������ viewport panel
	obj.pnPat = new Ext.Panel({
		id : 'pnPat'
		,layout : 'fit'
		,frame : true
		,width : pnWidth
		,title : '<img SRC="../scripts/dhcmed/img/PatInfo.png">���˻�����Ϣ����������д������ݣ�����Ӧѡ���"��"�д�̣�'
	});
	
	obj.pnSign = new Ext.Panel({
		id : 'pnSign'
		,layout : 'fit'
		,frame : true
		,width : pnWidth
		,title : '<img SRC="../scripts/dhcmed/img/DiseaseInfo.png">��Ҫ֢״������������Ӧ֢״��������"��"�д�̣�������дһ�'
	});
	
	obj.pnFood = new Ext.Panel({
		id : 'pnFood'
		,layout : 'fit'
		,frame : true
		,width : pnWidth
		,buttonAlign : 'center'
		,buttons : [obj.btnSaveFood,obj.btnDeleteFood]
	});
	
	obj.pnSample = new Ext.Panel({
		id : 'pnSample'
		,layout : 'fit'
		,frame : true
		,width : pnWidth
		,buttonAlign : 'center'
		,buttons : [obj.btnSaveSample,obj.btnDeleteSample]
	});
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,region : 'center'
		,layout : 'form'
		,frame : true
		,autoScroll : true
		,items : [
			obj.pnPat
			,obj.pnSign
			,obj.gridFood
			,obj.pnFood
			,obj.gridSample
			,obj.pnSample
		]
		,buttonAlign : 'center'
		,buttons : [
			obj.btnSaveTmp
			,obj.btnSaveRep
			,obj.btnExecheck
			,obj.btnCancheck
			,obj.btnReturn
			,obj.btnDelete
			,obj.btnReported
			,obj.btnPrint
			,obj.btnClose
		]
	});
	
	obj.MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'border'
		,items : [ obj.MainPanel ]
	});
	
	Ext.getCmp("pnPat").body.update(obj.PatHTML);
	Ext.getCmp("pnSign").body.update(obj.SignHTML);
	Ext.getCmp("pnFood").body.update(obj.FoodHTML);
	Ext.getCmp("pnSample").body.update(obj.SampleHTML);
	// ****************************** ������ viewport panel
	
	// ****************************** ������ xtemplate sign
	obj.divSignXTemplate = new Ext.XTemplate(
		'<tpl for="SignData">',
			'<table width="100%" class="" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="9%" class="xtplth1" style="text-align: right;">{Desc}</td>',
				'<td width="91%" class="xtpltd1"><table>',
					'<tpl if="this.isSub(IsSub)">',
						'<tpl for="SubData3">',
							'<tpl if="!this.isSub(IsSub)">',
								'<div style="float:left;width:270px;height:30px;">',
									'<input type="checkbox" id="chk{ID}" value="{chkID}" name="chkList" ',
									'<tpl if="this.isImpl(Impl)">checked="checked"</tpl> /> {Desc} ',
									'<tpl if="this.isExtra(ExtraTypeDesc)">',
										'<input type="text" id="txt{ID}" value="{ExtraText}" name="txtList" /> {ExtraUnit}',
									'</tpl>',
								'</div>',
							'</tpl>',
						'</tpl>',
						'<tpl for="SubData3">',
							'<tpl if="this.isSub(IsSub)">',
								'<table><tr>',
									'<td width="100px" class="">{Desc} : </td>',
									'<td width="900px" style="float:left;">',   //�����IE11������ģʽ����ʾΪ���е���ʽ
										'<tpl for="SubData6">',
											'<div style="float:left;width:120px;height:30px;">',
												'<input type="checkbox" id="chk{ID}" value="{chkID}" name="chkList" ',
												'<tpl if="this.isImpl(Impl)">checked="checked"</tpl> /> {Desc} ',
												'<tpl if="this.isExtra(ExtraTypeDesc)">',
													'<input type="text" id="txt{ID}" value="{ExtraText}" name="txtList" /> {ExtraUnit}',
												'</tpl>',
											'</div>',
										'</tpl>',
									'</td>',
								'</tr></table>',
							'</tpl>',
						'</tpl>',
					'</tpl>',
				'</table></td>',
			'</tr></table>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,isSub : function(IsSub) { return IsSub>0; }
			,isImpl : function(Impl) { return Impl==1; }
			,isExtra : function(ExtraTypeDesc) { return ExtraTypeDesc!="��"; }
		}
	);
	
	function buildSignData(Str) {
		var objData = Ext.decode(Str);
		var arrayData3 = new Array(), arrayData6 = new Array(), arrayData9 = new Array();
		for (var i=0; i<objData.total; i++) {
			var objTmp = objData.record[i];
			if (objTmp.Code.length==3) {
				arrayData3[arrayData3.length] = objTmp;
			} else if (objTmp.Code.length==6) {
				arrayData6[arrayData6.length] = objTmp;
			} else if (objTmp.Code.length==9) {
				arrayData9[arrayData9.length] = objTmp;
			}
		}
		var groupStr3 = "";
		for (var i=0; i<arrayData3.length; i++) {
			var objTmp3 = arrayData3[i];
			groupStr3 = groupStr3 + "{'ID':'" + objTmp3.ID;
			groupStr3 = groupStr3 + "','Code':'" + objTmp3.Code;
			groupStr3 = groupStr3 + "','Desc':'" + objTmp3.Desc;
			//groupStr3 = groupStr3 + "','ExtraTypeID':'" + objTmp3.ExtraTypeID;
			//groupStr3 = groupStr3 + "','ExtraTypeDesc':'" + objTmp3.ExtraTypeDesc;
			//groupStr3 = groupStr3 + "','ExtraUnit':'" + objTmp3.ExtraUnit;
			//groupStr3 = groupStr3 + "','Resume':'" + objTmp3.Resume;
			//groupStr3 = groupStr3 + "','ExtraText':'" + objTmp3.ExtraText;
			//groupStr3 = groupStr3 + "','Impl':'" + objTmp3.Impl;
			//groupStr3 = groupStr3 + "','chkID':'" + objTmp3.chkID;
			groupStr3 = groupStr3 + "','SubData3':";
			var groupStr6 = "", flgSub3 = 0;
			for (var j=0; j<arrayData6.length; j++) {
				var objTmp6 = arrayData6[j];
				if (objTmp6.Code.substring(0, 3)!=objTmp3.Code) { continue; }
				groupStr6 = groupStr6 + "{'ID':'" + objTmp6.ID;
				groupStr6 = groupStr6 + "','Code':'" + objTmp6.Code;
				groupStr6 = groupStr6 + "','Desc':'" + objTmp6.Desc;
				//groupStr6 = groupStr6 + "','ExtraTypeID':'" + objTmp6.ExtraTypeID;
				groupStr6 = groupStr6 + "','ExtraTypeDesc':'" + objTmp6.ExtraTypeDesc;
				groupStr6 = groupStr6 + "','ExtraUnit':'" + objTmp6.ExtraUnit;
				//groupStr6 = groupStr6 + "','Resume':'" + objTmp6.Resume;
				groupStr6 = groupStr6 + "','ExtraText':'" + objTmp6.ExtraText;
				groupStr6 = groupStr6 + "','Impl':'" + objTmp6.Impl;
				groupStr6 = groupStr6 + "','chkID':'" + objTmp6.chkID;
				groupStr6 = groupStr6 + "','SubData6':";
				var groupStr9 = "", flgSub6 = 0;
				for (var k=0; k<arrayData9.length; k++) {
					var objTmp9 = arrayData9[k];
					if (objTmp9.Code.substring(0, 6)!=objTmp6.Code) { continue; }
					groupStr9 = groupStr9 + "{'ID':'" + objTmp9.ID;
					groupStr9 = groupStr9 + "','Code':'" + objTmp9.Code;
					groupStr9 = groupStr9 + "','Desc':'" + objTmp9.Desc;
					//groupStr9 = groupStr9 + "','ExtraTypeID':'" + objTmp9.ExtraTypeID;
					groupStr9 = groupStr9 + "','ExtraTypeDesc':'" + objTmp9.ExtraTypeDesc;
					groupStr9 = groupStr9 + "','ExtraUnit':'" + objTmp9.ExtraUnit;
					//groupStr9 = groupStr9 + "','Resume':'" + objTmp9.Resume;
					groupStr9 = groupStr9 + "','ExtraText':'" + objTmp9.ExtraText;
					groupStr9 = groupStr9 + "','Impl':'" + objTmp9.Impl;
					groupStr9 = groupStr9 + "','chkID':'" + objTmp9.chkID +"'},";
					flgSub6++;
				}
				groupStr9 = groupStr9.substring(0, groupStr9.length-1);
				if (flgSub6>0) { groupStr9 = "[" + groupStr9 + "]" } else { groupStr9 = "''"; }
				groupStr6 = groupStr6 + groupStr9 + ",'IsSub':'" + flgSub6 +"'},";
				flgSub3++;
			}
			groupStr6 = groupStr6.substring(0, groupStr6.length-1);
			if (flgSub3>0) { groupStr6 = "[" + groupStr6 + "]" } else { groupStr6 = "''"; }
			groupStr3 = groupStr3 + groupStr6 + ",'IsSub':'" + flgSub3 +"'},";
		}
		groupStr3 = groupStr3.substring(0, groupStr3.length-1);
		var dataStr = "{SignData:[" + groupStr3 + "]}";
		var Data = Ext.decode(dataStr);
		return Data;
	}
	
	obj.renderSign = function(TargetElement, reportID, check) {
		var objTargetElement = document.getElementById(TargetElement);
		if (!objTargetElement) { return; }
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL
			,method : 'POST'
			,params : {
				ClassName : 'DHCMed.FBDService.ReportSrv',
				QueryName : 'QryReportSign',
				Arg1 : reportID,
				ArgCnt : 1
			}
			,success : function(response, opts) {
				var dataSign = buildSignData(response.responseText);
				obj.divSignXTemplate.compile();
				obj.divSignXTemplate.overwrite(TargetElement, dataSign);
				var chkListSign = document.getElementsByName("chkList");
				if (chkListSign) {
					for (var i=0; i<chkListSign.length; i++) {
						chkListSign[i].disabled = check;
					}
				}
				var txtListSign = document.getElementsByName("txtList");
				if (txtListSign) {
					for (var i=0; i<txtListSign.length; i++) {
						txtListSign[i].disabled = check;
					}
				}
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	// ****************************** ������ xtemplate sign
	
	// ****************************** ������ renderTo report
	obj.txtCardNo = new Ext.form.TextField({
		id : 'txtCardNo'
		//,fieldLabel : '�������'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divCardNo'
	});
	
	obj.txtOPNo = new Ext.form.TextField({
		id : 'txtOPNo'
		//,fieldLabel : '�����'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divOPNo'
	});
	
	obj.txtIPNo = new Ext.form.TextField({
		id : 'txtIPNo'
		//,fieldLabel : 'סԺ��'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divIPNo'
	});
	
	obj.txtPatName = new Ext.form.TextField({
		id : 'txtPatName'
		//,fieldLabel : '����'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divPatName'
	});
	
	obj.txtSex = new Ext.form.TextField({
		id : 'txtSex'
		//,fieldLabel : '�Ա�'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divSex'
	});
	
	obj.txtAge = new Ext.form.TextField({
		id : 'txtAge'
		//,fieldLabel : '����'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divAge'
	});
	
	obj.txtContactor = new Ext.form.TextField({
		id : 'txtContactor'
		//,fieldLabel : '�໤������'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divContactor'
	});
	
	obj.txtPersonalID = new Ext.form.TextField({
		id : 'txtPersonalID'
		//,fieldLabel : '���֤��'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divPersonalID'
	});
	
	obj.txtPatLevel = new Ext.form.TextField({
		id : 'txtPatLevel'
		//,fieldLabel : '���˼���'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divPatLevel'
	});
	
	obj.txtEncryptLevel = new Ext.form.TextField({
		id : 'txtEncryptLevel'
		//,fieldLabel : '�����ܼ�'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divEncryptLevel'
	});
	
	obj.txtTelephone = new Ext.form.TextField({
		id : 'txtTelephone'
		//,fieldLabel : '��ϵ��ʽ'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divTelephone'
	});
	
	obj.txtCompany = new Ext.form.TextField({
		id : 'txtCompany'
		//,fieldLabel : '��λ'
		,width : 440
		,anchor : '99%'
		,renderTo : 'divCompany'
	});
	
	obj.txtCurrAddress = new Ext.form.TextField({
		id : 'txtCurrAddress'
		//,fieldLabel : '��ס��ַ'
		,width : 440
		,anchor : '99%'
		,renderTo : 'divCurrAddress'
	});
	
	obj.txtCurrRoad = new Ext.form.TextField({
		id : 'txtCurrRoad'
		//,fieldLabel : '�ֵ�'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divCurrRoad'
	});
	
	obj.txtDisText = new Ext.form.TextField({
		id : 'txtDisText'
		//,fieldLabel : '������ע'
		,width : 170
		,anchor : '99%'
		,renderTo : 'divDisText'
	});
	
	obj.txtPreDiagnos = new Ext.form.TextArea({
		id : 'txtPreDiagnos'
		//,fieldLabel : '�������'
		,width : 440
		,height : 60
		,anchor : '99%'
		,renderTo : 'divPreDiagnos'
	});
	
	obj.txtAnamnesis = new Ext.form.TextArea({
		id : 'txtAnamnesis'
		//,fieldLabel : '������ʷ'
		,width : 440
		,height : 60
		,anchor : '99%'
		,renderTo : 'divAnamnesis'
	});
	obj.txtUseAntiDesc = new Ext.form.TextField({
		id : 'txtUseAntiDesc'
		//,fieldLabel : '����������'
		,width : 440
		,anchor : '99%'
		,renderTo : 'divUseAntiDesc'
	});
	obj.dtBirthday = new Ext.form.DateField({
		id : 'dtBirthday'
		//,fieldLabel : '��������'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 170
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divBirthday'
	});
	
	obj.dtSickDate = new Ext.form.DateField({
		id : 'dtSickDate'
		//,fieldLabel : '��������'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 90
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divSickDate'
	});
	
	obj.tmSickTime = new Ext.form.TimeField({
		id : 'tmSickTime'
		//,fieldLabel : '����ʱ��'
		,format : 'H:i:s'
		,width : 80
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divSickTime'
		,increment : 60
		,minListWidth : 90
	});
	
	obj.dtAdmitDate = new Ext.form.DateField({
		id : 'dtAdmitDate'
		//,fieldLabel : '��������'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 90
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divAdmitDate'
	});
	
	obj.tmAdmitTime = new Ext.form.TimeField({
		id : 'tmAdmitTime'
		//,fieldLabel : '����ʱ��'
		,format : 'H:i:s'
		,width : 80
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divAdmitTime'
		,increment : 60
		,minListWidth : 90
	});
	
	obj.dtDeathDate = new Ext.form.DateField({
		id : 'dtDeathDate'
		//,fieldLabel : '��������'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 90
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divDeathDate'
	});
	
	obj.tmDeathTime = new Ext.form.TimeField({
		id : 'tmDeathTime'
		//,fieldLabel : '����ʱ��'
		,format : 'H:i:s'
		,width : 80
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divDeathTime'
		,increment : 60
		,minListWidth : 90
	});
	
	obj.cboPatAreaStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboPatAreaStore = new Ext.data.Store({
		proxy : obj.cboPatAreaStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'myid'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'myid', mapping : 'myid' }
			,{ name : 'Description', mapping : 'Description' }
		])
	});
	obj.cboPatArea = new Ext.form.ComboBox({
		id : 'cboPatArea'
		,width : 170
		,valueField : 'myid'
		,displayField : 'Description'
		,minChars : 1
		//,fieldLabel : '��������'
		,store : obj.cboPatAreaStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divPatArea'
	});
	obj.cboPatAreaStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = 'FBDReportRegion';
		param.Arg2 = 1;
		param.ArgCnt = '2';
	});
	
	obj.cboOccupationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboOccupationStore = new Ext.data.Store({
		proxy : obj.cboOccupationStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'myid'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'myid', mapping : 'myid' }
			,{ name : 'Description', mapping : 'Description' }
		])
	});
	obj.cboOccupation = new Ext.form.ComboBox({
		id : 'cboOccupation'
		,width : 170
		,valueField : 'myid'
		,displayField : 'Description'
		,minChars : 1
		//,fieldLabel : '����ְҵ'
		,store : obj.cboOccupationStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divOccupation'
	});
	obj.cboOccupationStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = 'FBDOccupation';
		param.Arg2 = 1;
		param.ArgCnt = '2';
	});
	
	obj.cboCurrProvinceStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCurrProvinceStore = new Ext.data.Store({
		proxy : obj.cboCurrProvinceStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'RowID'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'RowID', mapping : 'RowID' }
			,{ name : 'ShortDesc', mapping : 'ShortDesc' }
		])
	});
	obj.cboCurrProvince = new Ext.form.ComboBox({
		id : 'cboCurrProvince'
		,width : 170
		,valueField : 'RowID'
		,displayField : 'ShortDesc'
		,minChars : 1
		//,fieldLabel : 'ʡ'
		,store : obj.cboCurrProvinceStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divCurrProvince'
	});
	obj.cboCurrProvinceStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.AreaDicSrv';
		param.QueryName = 'QryAreaDic';
		param.Arg1 = '';
		param.Arg2 = 1;
		param.ArgCnt = '2';
	});
	
	obj.cboCurrCityStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCurrCityStore = new Ext.data.Store({
		proxy : obj.cboCurrCityStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'RowID'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'RowID', mapping : 'RowID' }
			,{ name : 'ShortDesc', mapping : 'ShortDesc' }
		])
	});
	obj.cboCurrCity = new Ext.form.ComboBox({
		id : 'cboCurrCity'
		,width : 170
		,valueField : 'RowID'
		,displayField : 'ShortDesc'
		,minChars : 1
		//,fieldLabel : '��'
		,store : obj.cboCurrCityStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divCurrCity'
	});
	obj.cboCurrCityStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.AreaDicSrv';
		param.QueryName = 'QryAreaDic';
		param.Arg1 = obj.cboCurrProvince.getValue()==""?-1:obj.cboCurrProvince.getValue();
		param.Arg2 = 1;
		param.ArgCnt = '2';
	});
	
	obj.cboCurrCountyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCurrCountyStore = new Ext.data.Store({
		proxy : obj.cboCurrCountyStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'RowID'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'RowID', mapping : 'RowID' }
			,{ name : 'ShortDesc', mapping : 'ShortDesc' }
		])
	});
	obj.cboCurrCounty = new Ext.form.ComboBox({
		id : 'cboCurrCounty'
		,width : 170
		,valueField : 'RowID'
		,displayField : 'ShortDesc'
		,minChars : 1
		//,fieldLabel : '��'
		,store : obj.cboCurrCountyStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divCurrCounty'
	});
	obj.cboCurrCountyStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.AreaDicSrv';
		param.QueryName = 'QryAreaDic';
		param.Arg1 = obj.cboCurrCity.getValue()==""?-1:obj.cboCurrCity.getValue();
		param.Arg2 = 1;
		param.ArgCnt = '2';
	});
	
	obj.cboCurrVillageStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCurrVillageStore = new Ext.data.Store({
		proxy : obj.cboCurrVillageStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'RowID'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'RowID', mapping : 'RowID' }
			,{ name : 'ShortDesc', mapping : 'ShortDesc' }
		])
	});
	obj.cboCurrVillage = new Ext.form.ComboBox({
		id : 'cboCurrVillage'
		,width : 170
		,valueField : 'RowID'
		,displayField : 'ShortDesc'
		,minChars : 1
		//,fieldLabel : '��'
		,store : obj.cboCurrVillageStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divCurrVillage'
	});
	obj.cboCurrVillageStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.AreaDicSrv';
		param.QueryName = 'QryAreaDic';
		param.Arg1 = obj.cboCurrCounty.getValue()==""?-1:obj.cboCurrCounty.getValue();
		param.Arg2 = 1;
		param.ArgCnt = '2';
	});
	
	obj.cboDisCateStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDisCateStore = new Ext.data.Store({
		proxy : obj.cboDisCateStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'myid'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'myid', mapping : 'myid' }
			,{ name : 'Description', mapping : 'Description' }
		])
	});
	obj.cboDisCate = new Ext.form.ComboBox({
		id : 'cboDisCate'
		,width : 170
		,valueField : 'myid'
		,displayField : 'Description'
		,minChars : 1
		//,fieldLabel : '��������'
		,store : obj.cboDisCateStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divDisCate'
	});
	obj.cboDisCateStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = 'FBDDiseaseType';
		param.Arg2 = 1;
		param.ArgCnt = '2';
	});
	
	obj.cboDisDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDisDescStore = new Ext.data.Store({
		proxy : obj.cboDisDescStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'ID', mapping : 'ID' }
			,{ name : 'IDDesc', mapping : 'IDDesc' }
		])
	});
	obj.cboDisDesc = new Ext.form.ComboBox({
		id : 'cboDisDesc'
		,width : 170
		,valueField : 'ID'
		,displayField : 'IDDesc'
		,minChars : 1
		//,fieldLabel : '��������'
		,store : obj.cboDisDescStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divDisDesc'
	});
	obj.cboDisDescStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DiseaseSrv';
		param.QueryName = 'QryDisease';
		param.Arg1 = 'FBD';
		param.Arg2 = 1;
		param.Arg3 = obj.cboDisCate.getValue()==""?-1:obj.cboDisCate.getValue();
		param.ArgCnt = '3';
	});
	// ****************************** ������ renderTo report
	
	// ****************************** ������ renderTo food
	obj.txtFoodName = new Ext.form.TextField({
		id : 'txtFoodName'
		//,fieldLabel : 'ʳƷ����'
		,width : 240
		,anchor : '99%'
		,renderTo : 'divFoodName'
	});
	
	obj.txtFoodBrand = new Ext.form.TextField({
		id : 'txtFoodBrand'
		//,fieldLabel : 'ʳƷƷ��'
		,width : 240
		,anchor : '99%'
		,renderTo : 'divFoodBrand'
	});
	
	obj.txtManufacturer = new Ext.form.TextField({
		id : 'txtManufacturer'
		//,fieldLabel : '��������'
		,width : 240
		,anchor : '99%'
		,renderTo : 'divManufacturer'
	});
	obj.txtWhereToBuy = new Ext.form.TextField({
		id : 'txtWhereToBuy'
		//,fieldLabel : '����ص�'
		,width : 240
		,anchor : '99%'
		,renderTo : 'divWhereToBuy'
	});
	
	obj.txtEatingPlaces = new Ext.form.TextField({
		id : 'txtEatingPlaces'
		//,fieldLabel : '��ʳ����'
		,width : 240
		,anchor : '99%'
		,renderTo : 'divEatingPlaces'
	});
	
	obj.txtEatingNum = new Ext.form.TextField({
		id : 'txtEatingNum'
		//,fieldLabel : '��ʳ����'
		,width : 240
		,anchor : '99%'
		,renderTo : 'divEatingNum'
	});
	
	obj.dtEatingDate = new Ext.form.DateField({
		id : 'dtEatingDate'
		//,fieldLabel : '��ʳ����'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 120
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divEatingDate'
	});
	
	obj.tmEatingTime = new Ext.form.TimeField({
		id : 'tmEatingTime'
		//,fieldLabel : '��ʳʱ��'
		,format : 'H:i:s'
		,width : 120
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divEatingTime'
		,increment : 60
	});
	// ****************************** ������ renderTo food
	
	// ****************************** ������ renderTo sample
	obj.txtSampleNo = new Ext.form.TextField({
		id : 'txtSampleNo'
		//,fieldLabel : '�������'
		,width : 240
		,anchor : '99%'
		,renderTo : 'divSampleNo'
	});
	
	obj.txtSampleNumber = new Ext.form.TextField({
		id : 'txtSampleNumber'
		//,fieldLabel : '��������'
		,width : 240
		,anchor : '99%'
		,renderTo : 'divSampleNumber'
	});
	
	obj.txtSampleResume = new Ext.form.TextField({
		id : 'txtSampleResume'
		//,fieldLabel : '��ע'
		,width : 240
		,anchor : '99%'
		,renderTo : 'divSampleResume'
	});
	
	obj.dtSampleDate = new Ext.form.DateField({
		id : 'dtSampleDate'
		//,fieldLabel : '��������'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 240
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divSampleDate'
	});
	
	obj.cboSampleTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboSampleTypeStore = new Ext.data.Store({
		proxy : obj.cboSampleTypeStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'myid'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'myid', mapping : 'myid' }
			,{ name : 'Description', mapping : 'Description' }
		])
	});
	obj.cboSampleType = new Ext.form.ComboBox({
		id : 'cboSampleType'
		,width : 240
		,valueField : 'myid'
		,displayField : 'Description'
		,minChars : 1
		//,fieldLabel : '��������'
		,store : obj.cboSampleTypeStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divSampleType'
	});
	obj.cboSampleTypeStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = 'FBDSampleType';
		param.Arg2 = 1;
		param.ArgCnt = '2';
	});
	
	obj.cboSampleUnitStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboSampleUnitStore = new Ext.data.Store({
		proxy : obj.cboSampleUnitStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'myid'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'myid', mapping : 'myid' }
			,{ name : 'Description', mapping : 'Description' }
		])
	});
	obj.cboSampleUnit = new Ext.form.ComboBox({
		id : 'cboSampleUnit'
		,width : 240
		,valueField : 'myid'
		,displayField : 'Description'
		,minChars : 1
		//,fieldLabel : '��λ'
		,store : obj.cboSampleUnitStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,emptyText : '��ѡ��'
		,renderTo : 'divSampleUnit'
	});
	obj.cboSampleUnitStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = 'FBDSampleUnit';
		param.Arg2 = 1;
		param.ArgCnt = '2';
	});
	// ****************************** ������ renderTo sample
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
