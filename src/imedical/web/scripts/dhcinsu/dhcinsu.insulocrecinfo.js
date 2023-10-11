/*
 * FileName: dhcinsu.insulocrecinfo.js
 * Creator: WangXQ
 * Date: 2022-11-21
 * Description: ҽ�����Ҽ�¼��Ϣ
*/
var GV={
	HospDr:session['LOGON.HOSPID'],
	GUser:session['LOGON.USERID'],
	selectFlag:"",
	updataFlag:"",
	paperinfoStyle:"",
   }
   $(document).ready(function () {	
	   var hospComp = GenUserHospComp();
		$.extend(hospComp.jdata.options, {
			onSelect: function(index, row){
			   GV.HospDr=hospComp.getValue();
			   QryInLoc();
			   loadCombo();
			},
		});
	});
   $(function () {
		if(HISUIStyleCode == "lite") {
			GV.paperinfoStyle="<p class='myTooltip paperinfolite' style='padding:0 0 0 4px' title='������Ϣ' "
		}else{
			GV.paperinfoStyle="<img class='myTooltip' style='padding:0 0 0 4px' title='������Ϣ' src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_info.png'"
		}
	   setPageLayout();
	   setElementEvent();
   });
   
   function setPageLayout(){
	   //�������� ����ҽ��
	   $HUI.combobox("#deptName", {
		   panelHeight: 150,
		   method: 'GET',
		   valueField: 'cCode',
		   textField: 'cDesc',
		   blurValidValue: true,
		   defaultFilter: 5,
		   onChange:function(){
			   setValueById('deptCode',$("#deptName").combobox('getValue'));       //���ҿ��Ҵ���
		   },
	   });
	   //�����ϴ�״̬
	   $HUI.combobox("#upStatus", {
		   panelHeight: 160,
		   method: 'GET',
		   valueField: 'cCode',
		   textField: 'cDesc',
		   blurValidValue: true,
		   defaultFilter: 5,
	   });
	   //ҽ������
	   $HUI.combobox("#InsuType", {
		   panelHeight: 150,
		   method: 'GET',
		   valueField: 'cCode',
		   textField: 'cDesc',
		   blurValidValue: true,
		   defaultFilter: 5,
		   onLoadSuccess:function(){
			   $('#InsuType').combobox('select','00A');
		   },
	   });
	   //����Ԫ��
	   $('#locDlEd').hide();   
	   //��ʼ��������
	   loadCombo();
	   //��ʼ��ҽ������gd
	   InitInLocDg();
   }
   function setElementEvent(){
	   //ҽԺ���ұ���س��¼�
	   $("#hospDeptCode").keydown(function(e) { 
		   KeyWords_onkeydown(e);
	   }); 
	   $("#hospDeptName").keydown(function(e) { 
		   KeyWords_onkeydown(e);
		});
	   //��ѯ
	   $("#btnSearch").click(function(){
			QryInLoc();
	   });
	   //�ϴ�
	   $("#btnInLocUL").click(function(){
		   InLocUL();
	   })
	   //����
	   $("#btnInLocULCancel").click(function(){
		   InLocULCancel();
		 })
	   //���
	   $("#btnInLocULMod").click(function(){
		   InLocULMod();
		 })
	   //�����ϴ�
	   $("#btnInLocPLUL").click(function(){
		   InLocPLUL();
		 })
	   //���ձ���
	   $("#contrastSave").click(function(){
		   contrastSave();
		 })
   }
   //����������
   function loadCombo() {
	   //�������� ����ҽ�� dept00A
	   var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&ResultSetType=array&Type=dept00A&HospDr="+GV.HospDr;    
	   $("#deptName").combobox("clear").combobox("reload", url);
	   //�����ϴ�״̬ DeptUpldStas0
	   var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&ResultSetType=array&Type=DeptUpldStas00A&Code=&HospDr="+GV.HospDr;    
	   $("#upStatus").combobox("clear").combobox("reload", url);
	   //ҽ������
	   var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&ResultSetType=array&Type=DLLType&HospDr="+GV.HospDr;    
	   $("#InsuType").combobox("clear").combobox("reload", url);
   }
   
   //��ѯ��س��¼�
   function KeyWords_onkeydown(e)
   {
	   if (e.keyCode==13)
	   {
		   QryInLoc();
	   }
   }
   
   //��ѯ������Ϣ�¼�
   function QryInLoc()
   {
	   $('.contrastSave').linkbutton('disable');	//���ö��ձ��水ť������ʱ���
	   GV.selectFlag="";
	   var hospDeptCodg=$('#hospDeptCode').val();
	   var hospDeptName=$('#hospDeptName').val();
	   var caty=$('#deptCode').val();
	   var hiType=$("#InsuType").combobox('getValue');
	   var upStatus=$("#upStatus").combobox('getValue');
	   //alert(hospDeptCodg+""+hospDeptName+"||"+caty+"||"+hiType+"||"+upStatus)
	   $('#locdg').datagrid('reload',{
		   ClassName:'web.DHCINSULocInfoCtl',
		   QueryName:'QryCTLocInfo',
		   hospDeptCodg:hospDeptCodg ||'',
		   hospDeptName:hospDeptName ||'',
		   caty:caty ||'',
		   hiType:hiType,
		   upStatus:upStatus ||'',
		   hospDr:GV.HospDr,
	   });
   }
   
   //��ʼ��ҽ������gd
   function InitInLocDg()
   {
	   locdg=$HUI.datagrid("#locdg",{
		   url:$URL,
		   fit: true,
		   border: false,
		   rownumbers: true,
		   //singleSelect: true,
		   pageSize: 10,
		   pageList:[10,20,30],
		   pagination:true,
		   toolbar: '#toolBar',
		   frozenColumns:[[
			   {
			   
				   title: 'ck1',
				   field: 'ck1',
				   checkbox: true,
			   },
			   { 
				   field:'TOpt',
				   width:40,
				   title:'����',
				   formatter: function (value, row, index) {
						return GV.paperinfoStyle+"onclick=\"locEditClick('" + index+"')\" style='border:0px;cursor:pointer'>";
				   }
			   },
			   {field:'hosp_dept_codg',title:'ҽԺ���ұ���',width:140,
				   //formatter:function(value, row, index){return '<span  title="˫�����ж���">'+value+'</span>';},
			   },
			   {field:'hosp_dept_name',title:'ҽԺ��������',width:180},
			   {field:'caty',title:'���ҿ��Ҵ��� ',width:120,editor: 'text',
				   styler: function(value,row,index){
					   return 'pointer-events: none;'
				   },
			   },
			   {field:'catyDesc',title:'���ҿ�������',width:120,
			   editor:{
				   type: 'combogrid',
				   options: {
					   panelWidth: 440,
					   method: 'GET',
					   pagination: true,
					   idField: 'cDesc',
					   textField: 'cDesc',
					   mode: 'remote',
					   url: $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDicForDesc",
					   columns: [
					   [	
							{field: 'cCode', title: '���ҿ��Ҵ���', width: 120},
							{field: 'cDesc', title: '���ҿ�������', width: 230}]
					   ],
					   onBeforeLoad: function (param) {
					   
						   param.Type = "dept00A";
						   param.Desc =  param.q;
						   param.HospDr = GV.HospDr;
					   },
					   onSelect: function(rowIndex, rowData) {
						   var tr = $('#locdg').siblings().find('.datagrid-editable').parent().parent();//
						   var editIndex = tr.attr('datagrid-row-index')
						   var ed = $('#locdg').datagrid('getEditor', {index:editIndex,field:'caty'});
						   $(ed.target).val(rowData.cCode);
					   },
				   }
			   }},
			   {field:'up_status',title:'����״̬',width:100},
			   {field:'int',title:'int',width:30,hidden:true}
		   ]],
		   columns:[[
			   {field:'aprv_bed_cnt',title:'��׼��λ����',width:120},
			   {field:'hi_crtf_bed_cnt',title:'ҽ���Ͽɴ�λ��',width:120},
			   {field:'dept_estbdat',title:'��������',width:90},
			   {field:'dr_psncnt',title:'ҽʦ����',width:80},
			   {field:'phar_psncnt',title:'ҩʦ����',width:80},
			   {field:'nurs_psncnt',title:'��ʿ����',width:80},
			   {field:'tecn_psncnt',title:'��ʦ����',width:80},
			   {field:'dept_resper_name',title:'���Ҹ�����',width:100},
			   {field:'dept_resper_tel',title:'���Ҹ����˵绰',width:120},
			   {field:'itro',title:'���',width:100},
			   {field:'dept_med_serv_scp',title:'ҽ�Ʒ���Χ',width:120},
			   {field:'poolarea_no',title:'ͳ�������',width:100},
			   {field:'begntime',title:'��ʼʱ��',width:90},
			   {field:'endtime',title:'����ʱ��',width:90},
			   {field:'up_user',title:'������',width:80},
			   {field:'up_date',title:'��������',width:90},
			   {field:'up_time',title:'����ʱ��',width:90},
			   {field:'memo',title:'��ע',width:100},
			   {field:'ctLocId',title:'ctLocId',width:120},
			   {field:'inlocId',title:'inlocId',width:120},
			   {field:'inlocRecId',title:'inlocRecId',width:120},
			   {field:'dicRowid',title:'dicRowid',width:120,hidden:true}
			   
		   ]],
		   
		   onDblClickRow : function(index, row) {
			   editRow(index,row)
		   },
		   onCheckAll: function(rows) {
			   enableBtn();
			   $.each(rows, function (index, row) {
				   if ((row.up_status == "���ϴ�")||(row.up_status =="�ѱ��")){
					   locdg.uncheckRow(index);
					   locdg.unselectRow(index);
				   }
			   });
			   $('.btnInLocULMod').linkbutton('disable');
			   $('.btnInLocULCancel').linkbutton('disable');
		   },
		   onSelect: function (index, row) {
			   datagridDisable(index, row);
		   },
		   onCheck: function (index, row) {
			   datagridDisable(index, row);
		   },
		   onUncheck:function (index, row) {
			   var row=$('#locdg').datagrid('getSelections');
			   if(row==""){
				   GV.selectFlag=""
				   enableBtn();
			   }
		   },
		   onUnselect:function (index, row) {
			   var row=$('#locdg').datagrid('getSelections');
			   if(row==""){
				   GV.selectFlag=""
				   enableBtn();
			   }
		   },
		   onLoadSuccess: function () {
			   enableBtn();
		   }
	   });	
   }
   
   
   //���ؿ�����Ϣ
   function loadLocPanel(rowIndex, rowData)
   {
	   setValueById('DeptCode',rowData.hosp_dept_codg)
	   setValueById('DeptDesc',rowData.hosp_dept_name)
	   setValueById('DeptSetUpDate',rowData.dept_estbdat)
	   setValueById('StandDeptCode',rowData.catyDesc)
	   setValueById('ProfessionDeptCode',rowData.caty)
	   setValueById('DoctorNum',rowData.dr_psncnt)
	   setValueById('SPBedNum',rowData.aprv_bed_cnt)
	   setValueById('SJBedNum',rowData.hi_crtf_bed_cnt)
	   setValueById('PharmacistNum',rowData.phar_psncnt)
	   setValueById('StDate',rowData.begntime)
	   setValueById('EdDate',rowData.endtime)
	   setValueById('NurseNum',rowData.nurs_psncnt)
	   setValueById('DeptHead',rowData.dept_resper_name)
	   setValueById('DeptHeadTelNo',rowData.dept_resper_tel)
	   setValueById('TechnicianNum',rowData.tecn_psncnt)
	   setValueById('PoolareaNo',rowData.poolarea_no)
	   setValueById('itro',rowData.itro)
	   setValueById('medservscp',rowData.dept_med_serv_scp)
	   setValueById('Remark',rowData.memo)
	   setValueById('UserName',rowData.up_user)
	   setValueById('Date',rowData.up_date)
	   setValueById('Time',rowData.up_time)
	   setValueById('DeptDr',rowData.ctLocId)
	   setValueById('Rowid',rowData.inlocRecId)
   }
   
   function  locEditClick(rowIndex){
	   var rowData=$('#locdg').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');       
	   initLocFrm(rowIndex,rowData)
   }
   
   //��ʼ��������Ϣ��
   function initLocFrm(rowIndex, rowData)
   {      
	   loadLocPanel(rowIndex, rowData);
	   $('#locDlEd').show(); 
		   $HUI.dialog("#locDlEd",{
			   title:"������Ϣ",
			   height:450,
			   width:820,
			   iconCls: 'icon-w-paper',
			   modal:true
		   })
	   
   }
   ///******************************************************************
   
   ///******************************************************************
   ///����˵����CTLocInfoOpt
   //������Ϣ����ӿڵ��� 
   //�����ϴ�3401
   function InLocUL(){
	   var InsuType=$("#InsuType").combobox('getValue');
	   var row=$('#locdg').datagrid('getSelections');
	   if (InsuType==""){ 
		   $.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');
		   return;
	   }
	   if (row==""){
		   $.messager.confirm("��ʾ", "δѡ�п�����Ϣ���Ƿ��ϴ�ȫ������?", function (r) {
			   if (r) {
				   AInLocUL(row,InsuType)
			   }else{
				   return ;
			   }
		   })
	   }else{
		   AInLocUL(row,InsuType)
	   }
   }
   function AInLocUL(row,InsuType){
	   var input=""
	   if (row!=""){
			for(var i=0;i<row.length;i++){
		 		if(row[i].caty!=""){
					 if(input==""){
						 input=row[i].ctLocId
					 }else{
						 input=input+"^"+row[i].ctLocId
			 		}
				 }
			 }
	 		if(input==""){
				 $.messager.alert("��ʾ", "�����ϴ�ʧ��,ѡ�п��Ҿ�δ����", 'info');
				 return ;  
	 		}
		}
	   var ExpStr="3401"+"^"+GV.GUser+"^"+GV.HospDr+"^"+InsuType+"^"
	   $.messager.progress({
		   title: "��ʾ",
		   text: '�����ϴ�������Ϣ....'
		  });
	   //alert(input+"||"+ExpStr)
	   var RtnFLag=InsuLocInfoOpt("1",input,ExpStr); //DHCINSUPort.js
	   if(RtnFLag.split("^")[0]<0){
		   $.messager.progress("close");
		   $.messager.alert("��ʾ", "�����ϴ�ʧ��"+RtnFLag, 'info');
	   }else{
		   $.messager.progress("close");
		   $.messager.alert("��ʾ", "�����ϴ��ɹ�", 'info');
		   QryInLoc();
	   }
   }
   //���ұ��3402
   function InLocULMod()
   {
	   var InsuType=$("#InsuType").combobox('getValue');
	   var row=$('#locdg').datagrid('getSelections');
	   if (InsuType==""){ 
		   $.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');
		   return;
	   }
	   if (row==""){
		   $.messager.alert("��ʾ", "δѡ�п�����Ϣ", 'info');
		   return;
	   }
	   var input=""
	   for(var i=0;i<row.length;i++){
		   if(input==""){
			   input=row[i].inlocRecId
		   }else{
			   input=input+"^"+row[i].inlocRecId
		   }
	   }
	   if(input==""){
		   $.messager.alert("��ʾ", "���ұ��ʧ��,ѡ�м�¼��δ�ϴ�����,�޷����", 'info');
		   return;
	   }
	   var ExpStr="3402"+"^"+GV.GUser+"^"+GV.HospDr+"^"+InsuType+"^"
	   var RtnFLag=InsuLocInfoOpt("1",input,ExpStr); //DHCINSUPort.js
	   if(RtnFLag.split("^")[0]<0){
			$.messager.alert("��ʾ", "���ұ��ʧ��"+RtnFLag, 'info');  
		   }else{
		   $.messager.alert("��ʾ", "���ұ���ɹ�", 'info'); 
		   QryInLoc(); 
	   }
   }
   //���������ϴ�3401A
   function InLocPLUL()
   {
	   var InsuType=$("#InsuType").combobox('getValue');
	   var row=$('#locdg').datagrid('getSelections');
	   if (InsuType==""){ 
		   $.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');  
		   return;
	   }
	   if (row==""){
		   $.messager.confirm("��ʾ", "δѡ�п�����Ϣ���Ƿ��ϴ�ȫ������?", function (r) {
			   if (r) {
				   AInLocPLUL(row,InsuType)
			   }else{
				   return ;
			   }
		   })
	   }else{
		   AInLocPLUL(row,InsuType)
	   }
   }
   function AInLocPLUL(row,InsuType){
	   var input=""
	   if (row!=""){
	   		for(var i=0;i<row.length;i++){
				if(row[i].caty!=""){
					if(input==""){
						input=row[i].ctLocId
					}else{
						input=input+"^"+row[i].ctLocId
					}
				}
			}
			if(input==""){
				$.messager.alert("��ʾ", "���������ϴ�ʧ��,ѡ�п��Ҿ�δ����", 'info');
				return ;  
			}
	   }
	   $.messager.progress({
		   title: "��ʾ",
		   text: '�����ϴ�������Ϣ....'
		  });
	   var ExpStr="3401A"+"^"+GV.GUser+"^"+GV.HospDr+"^"+InsuType+"^"
	   //alert(input+"||"+ExpStr)
	   var RtnFLag=InsuLocInfoOpt("1",input,ExpStr); //DHCINSUPort.js
	   //alert(RtnFLag)
	   if(RtnFLag.split("^")[0]<0){
		   $.messager.progress("close");
		   $.messager.alert("��ʾ", "���������ϴ�ʧ��"+RtnFLag, 'info');  
		   }else{
			   $.messager.progress("close");
			   $.messager.alert("��ʾ", "���������ϴ��ɹ�", 'info'); 
			   QryInLoc(); 
	   }
   }
   //���ҳ���3403
   function InLocULCancel()
   {
	   var InsuType=$("#InsuType").combobox('getValue');
	   var row=$('#locdg').datagrid('getSelections');
	   var input=""
	   if (InsuType==""){ 
	   $.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');
		   return;
	   }
	   if (row==""){
		   $.messager.alert("��ʾ", "δѡ�п�����Ϣ", 'info');
		   return;
	   }
   
	   for(var i=0;i<row.length;i++){
		   if(input==""){
			   input=row[i].inlocRecId
		   }else{
			   input=input+"^"+row[i].inlocRecId
		   }
	   }
	   if(input==""){
		   $.messager.alert("��ʾ", "���ҳ���ʧ��,ѡ�м�¼��δ�ϴ�����,�޷�����", 'info');
		   return;
	   }
	   var ExpStr="3403"+"^"+GV.GUser+"^"+GV.HospDr+"^"+InsuType+"^"
	   //alert(input+"||"+ExpStr)
	   var RtnFLag=InsuLocInfoOpt("1",input,ExpStr); //DHCINSUPort.js
	   if(RtnFLag.split("^")[0]<0){
			$.messager.alert("��ʾ", "���ҳ���ʧ��"+RtnFLag, 'info');  
		   }else{
		   $.messager.alert("��ʾ", "���ҳ����ɹ�", 'info');
		   QryInLoc();
	   }
   }
   //�༭��
   function editRow(index,row){
	   var tr = $('#locdg').siblings().find('.datagrid-editable').parent().parent();//
	   var editIndex = tr.attr('datagrid-row-index') || -1;
	   if(editIndex!="-1"){
		   $.messager.alert("��ʾ","��δ����������ݣ����ȱ���!");
		   return
	   }
	   if(row.up_status!="���ϴ�"&&"�ѱ��"){
		   $('#locdg').datagrid('beginEdit', index);
		   $('.contrastSave').linkbutton('enable');
	   }
   }
   
   //���ձ���
   function contrastSave(){
	   var tr = $('#locdg').siblings().find('.datagrid-editable').parent().parent();//
	   var editRowIndex = tr.attr('datagrid-row-index') || -1;
	   if(editRowIndex==-1) {
		   $.messager.alert("��ʾ", "���Ƚ��ж���", 'info');  
		   return;
	   }
	   $('#locdg').datagrid('endEdit', editRowIndex);
	   var editRow = locdg.getRows()[editRowIndex];
	   if((editRow.caty=="")||(editRow.catyDesc=="")){
		   $.messager.alert("��ʾ", "���Ƚ��ж���", 'info');  
		   return;
	   }
	   var nowdata = new Date();
	   var tdata=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",nowdata.toLocaleDateString());
	   var ttime=tkMakeServerCall("websys.Conversions","TimeHtmlToLogical",nowdata.toLocaleTimeString());
	   var remarks=GV.GUser+"|"+tdata+"|"+ttime;
	   var inStr=editRow.dicRowid+"^"+"deptCon00A"+"^"+editRow.hosp_dept_codg+"^"+editRow.hosp_dept_name+"^"+editRow.caty+"^"+editRow.catyDesc+"^"+remarks+"^^^^^^^^^"+GV.HospDr;
	   //alert(inStr)
	   var rtnStr=tkMakeServerCall("web.INSUDicDataCom","CheckInDic",inStr);
	   if(rtnStr<0){
		   $.messager.alert("��ʾ", "����ʧ��", 'info');  
		  }else{
		  $.messager.alert("��ʾ", "����ɹ�", 'info');
		  QryInLoc();
	  }
   }
   
   //�����ť���ã�
   function enableBtn(){
	   $('.btnInLocUL').linkbutton('enable');
	   $('.btnInLocULMod').linkbutton('enable');
	   $('.btnInLocULCancel').linkbutton('enable');
	   $('.btnInLocPLUL').linkbutton('enable');
   }
   //
   function datagridDisable (index, row){
	   if (GV.selectFlag==""){
		   if((row.up_status=="δ�ϴ�")||(row.up_status=="����")){
			   GV.selectFlag="1"
			   $('.btnInLocULMod').linkbutton('disable');
			   $('.btnInLocULCancel').linkbutton('disable');
		   }else if((row.up_status=="���ϴ�")||(row.up_status=="�ѱ��")){
			   GV.selectFlag="2"
			   $('.btnInLocUL').linkbutton('disable');
			   $('.btnInLocPLUL').linkbutton('disable');
		   }
	   }
	   if(GV.selectFlag=="1"){
		   if ((row.up_status == "���ϴ�")||(row.up_status =="�ѱ��")){
			   locdg.uncheckRow(index);
			   locdg.unselectRow(index);
		   }
	   }
	   if(GV.selectFlag=="2"){
		   if ((row.up_status == "δ�ϴ�")||(row.up_status =="�ѳ���")){
			   locdg.uncheckRow(index);
			   locdg.unselectRow(index);
		   }
	   }
   }
   
   
   
   
   
   
