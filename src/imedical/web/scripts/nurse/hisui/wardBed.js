/**
 *@description 病区查询js
 *@csp nur.hisui.wardBed.csp
 */
 var loginHospID = session['LOGON.HOSPID'];
 var GV = {
	 ClassName: "Nur.HISUI.WardBed",
 };
 var init = function () {
	 InitCombobox();
	 InitFilterCombobox();
	 initPageDom();
 }
 $(init)
 
 /**
  *@description 初始化下拉数据
  */
 function InitCombobox(){
	 $cm({
		 ClassName: GV.ClassName,
		 MethodName: "GetHospitalList"
	 }, function (jsonData) {
		 $("#hospital").combobox({
			 valueField:'id',
			 textField:'desc',
			 mode: "local",
 //			multiple:true,
 //			rowStyle:'checkbox', //显示成勾选行形式
			 data:jsonData,
			 value:loginHospID,
			 onAllSelectClick:function(e){
				 var hospId = $('#hospital').combobox('getValues');
				 hospIDs = "";
				 hospId.forEach(function (id) {
					 hospIDs = hospIDs + "^" + id;
				 });
				 if(hospIDs != ""){
					 loginHospID = hospIDs;
				 }
				 var value=$HUI.searchbox('#search').getValue();
				 $('#wardBeds').datagrid('reload', {
					 ClassName: GV.ClassName,
					 MethodName: "GetWardBedsInfo",
					 desc:value,
					 hospId:hospIDs,
					 userId:session['LOGON.USERID'],
					 groupId:session['LOGON.GROUPID'],
					 filterFlag: $('#comboFilter').combobox('getValue')
				 });
			 },
			 onSelect:function(e){
				 var hospId = $('#hospital').combobox('getValues');
				 hospIDs = "";
				 hospId.forEach(function (id) {
					 hospIDs = hospIDs + "^" + id;
				 });
				 if(hospIDs != ""){
					 loginHospID = hospIDs;
				 }
				 var value=$HUI.searchbox('#search').getValue();
				 $('#wardBeds').datagrid('reload', {
					 ClassName: GV.ClassName,
					 MethodName: "GetWardBedsInfo",
					 desc:value,
					 hospId:hospIDs,
					 userId:session['LOGON.USERID'],
					 groupId:session['LOGON.GROUPID'],
					 filterFlag: $('#comboFilter').combobox('getValue')
				 });
			 }
		 });
	 });
	 initEvent();
 }
 
 function InitFilterCombobox(){
	 $HUI.combobox('#comboFilter', {
		 valueField: 'id',
		 textField: 'text',
		 value: tkMakeServerCall("Nur.HISUI.WardBed","comboboxDefaultVal",session['LOGON.USERID'],"get",""),
		 data:[
			 {id:1, text:$g("全部")},
			 {id:2, text:$g("按人筛选")},
			 {id:3, text:$g("按安全组筛选")}
		 ],
		 onChange:function(newval, oldval){
			 tkMakeServerCall("Nur.HISUI.WardBed","comboboxDefaultVal",session['LOGON.USERID'],"save",newval);
			 var value=$HUI.searchbox('#search').getValue();
			 $('#wardBeds').datagrid('reload', {
				 ClassName: GV.ClassName,
				 MethodName: "GetWardBedsInfo",
				 desc:value,
				 hospId:loginHospID,
				 userId:session['LOGON.USERID'],
				 groupId:session['LOGON.GROUPID'],
				 filterFlag: $('#comboFilter').combobox('getValue')
			 });
		 },
			 //defaultFilter:4
	 });
 }
 
 function initEvent() {
	 $('#search').searchbox({
		 searcher: function(value) {
			 $('#wardBeds').datagrid('reload', {
				 ClassName: GV.ClassName,
				 MethodName: "GetWardBedsInfo",
				 desc:value,
				 hospId:loginHospID,
				 userId:session['LOGON.USERID'],
				 groupId:session['LOGON.GROUPID'],
				 filterFlag: $('#comboFilter').combobox('getValue')
			 });
		 },
		 prompt: $g('请输入病区关键字')
	 });
 }
 
 function initPageDom() {
	  $HUI.datagrid('#wardBeds', {
		 url: $URL,
		 queryParams: {
			 ClassName: GV.ClassName,
			 MethodName: "GetWardBedsInfo",
				desc:"",
			 hospId:loginHospID,
			 userId:session['LOGON.USERID'],
			 groupId:session['LOGON.GROUPID'],
			 filterFlag: $('#comboFilter').combobox('getValue')
		 },
		 rownumbers:true,
		 frozenColumns:[[
			 { field: 'wardCode', title: '病房代码', width: 200,align:'center'},
			 { field: 'bedChart', title: '床位图', width: 80,align:'center',formatter: operCellStyler},
		 ]],
		 columns: [[
			 { field: 'total', title: '总床', width: 80,align:'center'},
			 { field: 'emptyBedNum', title: '空床数', width: 80,align:'center'},
			 //{ field: 'patientNum', title: '在院患者数', width: 100,align:'center'},
			 { field: 'inBedPatNum', title: '在床患者数', width: 100,align:'center'},
			 { field: 'waitPatientNum', title: '等候区患者', width: 100,align:'center'},
			 { field: 'disNum', title: '今出/明出', width:100,align:'center'},
			 { field: 'MaleNum', title: '男床', width: 80,align:'center'},
			 { field: 'FeMaleNum', title: '女床', width: 80,align:'center'},
			 { field: 'OtherNum', title: '不限', width: 80,align:'center'},
			 { field: 'blockBedNum', title: '锁定', width: 80,align:'center'},
			 { field: 'AvailNum', title: '可用', width: 80,align:'center'},
			 { field: 'UnavailNum', title: '不可用', width: 80,align:'center'},
			 { field: 'todayAppBedNum', title: '今日已签床', width: 100,align:'center'},
			 { field: 'tomorrowAppBedNum', title: '明日已签床', width: 100,align:'center'},
			 { field: 'CTLBDesc', title: '位置', width: 100,align:'center'},
			 { field: 'hospital', title: '医院', width: 200,align:'center'},
			 { field: 'wardID', title: '病区ID', width:120,hidden:true,align:'center'},		
		 ]],
		 idField: 'wardID',
		 rownumbers: true,
		 pagination: false,
		 pageSize: 15,
		 pageList: [15,30,50,100],
		 singleSelect:true,
		 headerCls:'panel-header-gray',
		 border:false,
	 })
 }
 function operCellStyler(value, row, index) {
	 return '<a href="#" class="cancelReleaseBtn fa fa-bed fa-lg rowBtnLocation" onclick="goBedChart(\'' + String(row.bedChart) +'\',\''+row.wardCode+'\')"></a>';
 }
 function goBedChart(link,bedDesc)
 {
	 //window.location.href=link;
	 //window.showModalDialog(link, window, "dialogWidth:1400px;status:no;dialogHeight:800px");
	 //window.open(link, window, "width:90%;status:no;dialogHeight:800px");
	 websys_showModal({
		 url:link,
		 title:bedDesc+$g('床位图'),
		 width:'95%',height:'90%',
		 closable:true
	 })
 }
 function changeColor(value)
 {
	 if(value>0) return 'color:green;font-weight:bold';
 }

 function configSet()
 {
	 var src="nur.hisui.wardBedConfig.csp?";
	 var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	 createModalDialog("Find","查询配置", 1200, 800,"icon-w-card","",$code,"");
 }
 
  
 /// <script type="text/javascript" src="../scripts/Doc.PatListQuery.hui.js"></script>
 function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
	 $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
	 if (_width == null)
		 _width = 800;
	 if (_height == null)
		 _height = 500;
	 $("#"+id).dialog({
		 title: _title,
		 width: _width,
		 height: _height,
		 cache: false,
		 iconCls: _icon,
		 //href: _url,
		 collapsible: false,
		 minimizable:false,
		 maximizable: false,
		 resizable: false,
		 modal: true,
		 closed: false,
		 closable: true,
		 content:_content,
		 onClose:function(){
			 destroyDialog(id);
		 }
	 });
 }
 
 function destroyDialog(id){
	//移除存在的Dialog
	$("body").remove("#"+id); 
	$("#"+id).dialog('destroy');
 }