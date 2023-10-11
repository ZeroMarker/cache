var hospid = session['LOGON.HOSPID'];

$(function(){//初始化
    Initmain();
    $('#ReportItemCodeBox').val('')
    $('#ReportItemNameBox').val('')
}); 
 
function Initmain(){
//明细表
	DetailColumns=[[{
	     field:'ReportTempletDetailID',
	     hidden: true
	     },{
	     field:'ReportTempletID',
	     title:'会计报表模板ID',
	     hidden: true
	     },{
		 field:'ReportItemCode',
		 title:'报表项编码',
		 width:120,
		 align:'left',
		 halign:'left',
		 editor:{
		     type:'validatebox',
		     options:{
			     required:true,
			     validType:['a','b','c']
			     }}
		 },{
	     field:'ReportItemName',
	     title:'报表项名称',
	     width:280,
		 align:'left',
		 halign:'left',
		 editor:{
		     type:'validatebox',
		     options:{
			     required:true}}
	     },{
		 field:'FormulaDesc',
		 title:'项目公式描述',
		 width:300,
		 align:'left',
		 halign:'left',
		 editor:{type:'text',}
		 },{
		 field:'FormulaCode',
         title:'项目公式编码',
         width:300,
		 align:'left',
		 halign:'left',
		 hidden:true,
		 editor:{type:'text'}	
		 },{
	     field:'RowNo',
	     title:'所属行',
	     width:80,
	     align:'center',
	     halign:'center',
	     editor:{type:'text'}
	     },{
		 field:'ColNO',
		 title:'所属列',
		 width:80,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'CompOrderNo',
		 title:'计算顺序',
		 width:80,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'DispType',
		 title:'显示类型',
		 width:100, 
		 align:'left',
		 halign:'left',
		 formatter:comboboxFormatter,
		 editor:{
			 type:'combobox',
			 options:{
				 valueField:'rowid',
				 textField:'name',
				 data:[
				 {rowid:'0',name:'显示'},
				 {rowid:'1',name:'不显示'}],
				 }}
	     },{
	     field:'DispDistribution',
	     title:'显示分区',
	     width:80,
	     align:'left',
	     halign:'left',
	     editor:{type:'text'}
		 },{
		 field:'InitValue',
		 title:'默认值',
		 width:100,
		 align:'left',
		 halign:'left',
		 editor:{type:'text'}
		 }]]    
        
      var detailtableObj = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        rownumbers:true,//行号
        singleSelect: true, 
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : true,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
        nowrap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        toolbar: '#dtb',
        columns:DetailColumns,
        })
        
         // 查询 
  $("#DetailFindBtn").click(function(){
	  var row=$('#MainGrid').datagrid("getSelected");
	  if(row==null){
		  $.messager.popover({
		      msg:'请先选择报表！',
		      timeout: 2000,type:'alert',
		      showType: 'show',
		      style:{"position":"absolute","z-index":"9999",
			         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			         top:1}})
			         return;
		  }
	    var ReportItemCode   = $('#ReportItemCodeBox').val()
        var ReportItemName   = $('#ReportItemNameBox').val()
         
        detailtableObj.load({
                ClassName: "herp.budg.hisui.udata.uReportTemplet",
                MethodName: "DetailList",
                ReportTempletID:row.rowid, 
                ReportItemCode : ReportItemCode,
                ReportItemName : ReportItemName,
            })});
        
           
        }