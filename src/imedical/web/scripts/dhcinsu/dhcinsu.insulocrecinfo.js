/*
 * FileName: dhcinsu.insulocrecinfo.js
 * Creator: WangXQ
 * Date: 2022-11-21
 * Description: 医保科室记录信息
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
			GV.paperinfoStyle="<p class='myTooltip paperinfolite' style='padding:0 0 0 4px' title='科室信息' "
		}else{
			GV.paperinfoStyle="<img class='myTooltip' style='padding:0 0 0 4px' title='科室信息' src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_info.png'"
		}
	   setPageLayout();
	   setElementEvent();
   });
   
   function setPageLayout(){
	   //科室名称 国家医保
	   $HUI.combobox("#deptName", {
		   panelHeight: 150,
		   method: 'GET',
		   valueField: 'cCode',
		   textField: 'cDesc',
		   blurValidValue: true,
		   defaultFilter: 5,
		   onChange:function(){
			   setValueById('deptCode',$("#deptName").combobox('getValue'));       //国家科室代码
		   },
	   });
	   //科室上传状态
	   $HUI.combobox("#upStatus", {
		   panelHeight: 160,
		   method: 'GET',
		   valueField: 'cCode',
		   textField: 'cDesc',
		   blurValidValue: true,
		   defaultFilter: 5,
	   });
	   //医保类型
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
	   //隐藏元素
	   $('#locDlEd').hide();   
	   //初始化下拉框
	   loadCombo();
	   //初始化医保科室gd
	   InitInLocDg();
   }
   function setElementEvent(){
	   //医院科室编码回车事件
	   $("#hospDeptCode").keydown(function(e) { 
		   KeyWords_onkeydown(e);
	   }); 
	   $("#hospDeptName").keydown(function(e) { 
		   KeyWords_onkeydown(e);
		});
	   //查询
	   $("#btnSearch").click(function(){
			QryInLoc();
	   });
	   //上传
	   $("#btnInLocUL").click(function(){
		   InLocUL();
	   })
	   //撤销
	   $("#btnInLocULCancel").click(function(){
		   InLocULCancel();
		 })
	   //变更
	   $("#btnInLocULMod").click(function(){
		   InLocULMod();
		 })
	   //批量上传
	   $("#btnInLocPLUL").click(function(){
		   InLocPLUL();
		 })
	   //对照保存
	   $("#contrastSave").click(function(){
		   contrastSave();
		 })
   }
   //加载下拉框
   function loadCombo() {
	   //科室名称 国家医保 dept00A
	   var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&ResultSetType=array&Type=dept00A&HospDr="+GV.HospDr;    
	   $("#deptName").combobox("clear").combobox("reload", url);
	   //科室上传状态 DeptUpldStas0
	   var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic&ResultSetType=array&Type=DeptUpldStas00A&Code=&HospDr="+GV.HospDr;    
	   $("#upStatus").combobox("clear").combobox("reload", url);
	   //医保类型
	   var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&ResultSetType=array&Type=DLLType&HospDr="+GV.HospDr;    
	   $("#InsuType").combobox("clear").combobox("reload", url);
   }
   
   //查询框回车事件
   function KeyWords_onkeydown(e)
   {
	   if (e.keyCode==13)
	   {
		   QryInLoc();
	   }
   }
   
   //查询科室信息事件
   function QryInLoc()
   {
	   $('.contrastSave').linkbutton('disable');	//禁用对照保存按钮，对照时解除
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
   
   //初始化医保科室gd
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
				   title:'操作',
				   formatter: function (value, row, index) {
						return GV.paperinfoStyle+"onclick=\"locEditClick('" + index+"')\" style='border:0px;cursor:pointer'>";
				   }
			   },
			   {field:'hosp_dept_codg',title:'医院科室编码',width:140,
				   //formatter:function(value, row, index){return '<span  title="双击进行对照">'+value+'</span>';},
			   },
			   {field:'hosp_dept_name',title:'医院科室名称',width:180},
			   {field:'caty',title:'国家科室代码 ',width:120,editor: 'text',
				   styler: function(value,row,index){
					   return 'pointer-events: none;'
				   },
			   },
			   {field:'catyDesc',title:'国家科室名称',width:120,
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
							{field: 'cCode', title: '国家科室代码', width: 120},
							{field: 'cDesc', title: '国家科室名称', width: 230}]
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
			   {field:'up_status',title:'经办状态',width:100},
			   {field:'int',title:'int',width:30,hidden:true}
		   ]],
		   columns:[[
			   {field:'aprv_bed_cnt',title:'批准床位数量',width:120},
			   {field:'hi_crtf_bed_cnt',title:'医保认可床位数',width:120},
			   {field:'dept_estbdat',title:'成立日期',width:90},
			   {field:'dr_psncnt',title:'医师人数',width:80},
			   {field:'phar_psncnt',title:'药师人数',width:80},
			   {field:'nurs_psncnt',title:'护士人数',width:80},
			   {field:'tecn_psncnt',title:'技师人数',width:80},
			   {field:'dept_resper_name',title:'科室负责人',width:100},
			   {field:'dept_resper_tel',title:'科室负责人电话',width:120},
			   {field:'itro',title:'简介',width:100},
			   {field:'dept_med_serv_scp',title:'医疗服务范围',width:120},
			   {field:'poolarea_no',title:'统筹区编号',width:100},
			   {field:'begntime',title:'开始时间',width:90},
			   {field:'endtime',title:'结束时间',width:90},
			   {field:'up_user',title:'经办人',width:80},
			   {field:'up_date',title:'经办日期',width:90},
			   {field:'up_time',title:'经办时间',width:90},
			   {field:'memo',title:'备注',width:100},
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
				   if ((row.up_status == "已上传")||(row.up_status =="已变更")){
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
   
   
   //加载科室信息
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
   
   //初始化科室信息框
   function initLocFrm(rowIndex, rowData)
   {      
	   loadLocPanel(rowIndex, rowData);
	   $('#locDlEd').show(); 
		   $HUI.dialog("#locDlEd",{
			   title:"科室信息",
			   height:450,
			   width:820,
			   iconCls: 'icon-w-paper',
			   modal:true
		   })
	   
   }
   ///******************************************************************
   
   ///******************************************************************
   ///功能说明：CTLocInfoOpt
   //科室信息管理接口调用 
   //科室上传3401
   function InLocUL(){
	   var InsuType=$("#InsuType").combobox('getValue');
	   var row=$('#locdg').datagrid('getSelections');
	   if (InsuType==""){ 
		   $.messager.alert("提示", "请选择医保类型", 'info');
		   return;
	   }
	   if (row==""){
		   $.messager.confirm("提示", "未选中科室信息，是否上传全部科室?", function (r) {
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
				 $.messager.alert("提示", "科室上传失败,选中科室均未对照", 'info');
				 return ;  
	 		}
		}
	   var ExpStr="3401"+"^"+GV.GUser+"^"+GV.HospDr+"^"+InsuType+"^"
	   $.messager.progress({
		   title: "提示",
		   text: '正在上传科室信息....'
		  });
	   //alert(input+"||"+ExpStr)
	   var RtnFLag=InsuLocInfoOpt("1",input,ExpStr); //DHCINSUPort.js
	   if(RtnFLag.split("^")[0]<0){
		   $.messager.progress("close");
		   $.messager.alert("提示", "科室上传失败"+RtnFLag, 'info');
	   }else{
		   $.messager.progress("close");
		   $.messager.alert("提示", "科室上传成功", 'info');
		   QryInLoc();
	   }
   }
   //科室变更3402
   function InLocULMod()
   {
	   var InsuType=$("#InsuType").combobox('getValue');
	   var row=$('#locdg').datagrid('getSelections');
	   if (InsuType==""){ 
		   $.messager.alert("提示", "请选择医保类型", 'info');
		   return;
	   }
	   if (row==""){
		   $.messager.alert("提示", "未选中科室信息", 'info');
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
		   $.messager.alert("提示", "科室变更失败,选中记录尚未上传或变更,无法变更", 'info');
		   return;
	   }
	   var ExpStr="3402"+"^"+GV.GUser+"^"+GV.HospDr+"^"+InsuType+"^"
	   var RtnFLag=InsuLocInfoOpt("1",input,ExpStr); //DHCINSUPort.js
	   if(RtnFLag.split("^")[0]<0){
			$.messager.alert("提示", "科室变更失败"+RtnFLag, 'info');  
		   }else{
		   $.messager.alert("提示", "科室变更成功", 'info'); 
		   QryInLoc(); 
	   }
   }
   //科室批量上传3401A
   function InLocPLUL()
   {
	   var InsuType=$("#InsuType").combobox('getValue');
	   var row=$('#locdg').datagrid('getSelections');
	   if (InsuType==""){ 
		   $.messager.alert("提示", "请选择医保类型", 'info');  
		   return;
	   }
	   if (row==""){
		   $.messager.confirm("提示", "未选中科室信息，是否上传全部科室?", function (r) {
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
				$.messager.alert("提示", "科室批量上传失败,选中科室均未对照", 'info');
				return ;  
			}
	   }
	   $.messager.progress({
		   title: "提示",
		   text: '正在上传科室信息....'
		  });
	   var ExpStr="3401A"+"^"+GV.GUser+"^"+GV.HospDr+"^"+InsuType+"^"
	   //alert(input+"||"+ExpStr)
	   var RtnFLag=InsuLocInfoOpt("1",input,ExpStr); //DHCINSUPort.js
	   //alert(RtnFLag)
	   if(RtnFLag.split("^")[0]<0){
		   $.messager.progress("close");
		   $.messager.alert("提示", "科室批量上传失败"+RtnFLag, 'info');  
		   }else{
			   $.messager.progress("close");
			   $.messager.alert("提示", "科室批量上传成功", 'info'); 
			   QryInLoc(); 
	   }
   }
   //科室撤销3403
   function InLocULCancel()
   {
	   var InsuType=$("#InsuType").combobox('getValue');
	   var row=$('#locdg').datagrid('getSelections');
	   var input=""
	   if (InsuType==""){ 
	   $.messager.alert("提示", "请选择医保类型", 'info');
		   return;
	   }
	   if (row==""){
		   $.messager.alert("提示", "未选中科室信息", 'info');
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
		   $.messager.alert("提示", "科室撤销失败,选中记录尚未上传或变更,无法撤销", 'info');
		   return;
	   }
	   var ExpStr="3403"+"^"+GV.GUser+"^"+GV.HospDr+"^"+InsuType+"^"
	   //alert(input+"||"+ExpStr)
	   var RtnFLag=InsuLocInfoOpt("1",input,ExpStr); //DHCINSUPort.js
	   if(RtnFLag.split("^")[0]<0){
			$.messager.alert("提示", "科室撤销失败"+RtnFLag, 'info');  
		   }else{
		   $.messager.alert("提示", "科室撤销成功", 'info');
		   QryInLoc();
	   }
   }
   //编辑行
   function editRow(index,row){
	   var tr = $('#locdg').siblings().find('.datagrid-editable').parent().parent();//
	   var editIndex = tr.attr('datagrid-row-index') || -1;
	   if(editIndex!="-1"){
		   $.messager.alert("提示","有未保存的行数据，请先保存!");
		   return
	   }
	   if(row.up_status!="已上传"&&"已变更"){
		   $('#locdg').datagrid('beginEdit', index);
		   $('.contrastSave').linkbutton('enable');
	   }
   }
   
   //对照保存
   function contrastSave(){
	   var tr = $('#locdg').siblings().find('.datagrid-editable').parent().parent();//
	   var editRowIndex = tr.attr('datagrid-row-index') || -1;
	   if(editRowIndex==-1) {
		   $.messager.alert("提示", "请先进行对照", 'info');  
		   return;
	   }
	   $('#locdg').datagrid('endEdit', editRowIndex);
	   var editRow = locdg.getRows()[editRowIndex];
	   if((editRow.caty=="")||(editRow.catyDesc=="")){
		   $.messager.alert("提示", "请先进行对照", 'info');  
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
		   $.messager.alert("提示", "保存失败", 'info');  
		  }else{
		  $.messager.alert("提示", "保存成功", 'info');
		  QryInLoc();
	  }
   }
   
   //解除按钮禁用，
   function enableBtn(){
	   $('.btnInLocUL').linkbutton('enable');
	   $('.btnInLocULMod').linkbutton('enable');
	   $('.btnInLocULCancel').linkbutton('enable');
	   $('.btnInLocPLUL').linkbutton('enable');
   }
   //
   function datagridDisable (index, row){
	   if (GV.selectFlag==""){
		   if((row.up_status=="未上传")||(row.up_status=="撤销")){
			   GV.selectFlag="1"
			   $('.btnInLocULMod').linkbutton('disable');
			   $('.btnInLocULCancel').linkbutton('disable');
		   }else if((row.up_status=="已上传")||(row.up_status=="已变更")){
			   GV.selectFlag="2"
			   $('.btnInLocUL').linkbutton('disable');
			   $('.btnInLocPLUL').linkbutton('disable');
		   }
	   }
	   if(GV.selectFlag=="1"){
		   if ((row.up_status == "已上传")||(row.up_status =="已变更")){
			   locdg.uncheckRow(index);
			   locdg.unselectRow(index);
		   }
	   }
	   if(GV.selectFlag=="2"){
		   if ((row.up_status == "未上传")||(row.up_status =="已撤销")){
			   locdg.uncheckRow(index);
			   locdg.unselectRow(index);
		   }
	   }
   }
   
   
   
   
   
   
