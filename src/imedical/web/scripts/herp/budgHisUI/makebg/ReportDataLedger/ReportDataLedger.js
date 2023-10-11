var hospid=session['LOGON.HOSPID'];

$(function(){//初始化
    Initmain();
    $('#ReportCodeBox').val('');
    $('#ReportNameBox').val('')
}); 

  //点击事件
   function RoportDetail(value){
     var $reportwin;
     $reportwin = $('#winreport').window({
        width: 1100,
        height: 600,
        top: ($(window).height() - 600) * 0.5,
	    left: ($(window).width() - 1100) * 0.5,
        draggable:true,
        shadow: true,
        modal: true,
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        content  : '<iframe style="width:100%;height:100%" src="dhccpmrunqianreport.csp?reportName=herp.budg.hisui.report.'+value+'.raq" /></iframe>'
        })
        	 
	   $('#winreport').panel({title: value});
	   $('#winreport').window('open');
	   }
	   
 //定义报表窗口
 
 
function Initmain(){	    
	MainColumns=[[{
	     field:'ReportTempletID',
	     hidden: true
	     },{
	     field:'CompDR',
	     hidden: true
	     },{
	     field:'ReportCode',
	     title:'报表编码',
	     width:150,
	     allowBlank:false,
	     required:true,
	     align:'left',
	     halign:'left',
	     },{
		 field:'ReportName',
		 title:'报表名称',
		 width:200,
		 align:'left',
		 allowBlank:false,
		 required:true,
		 halign:'left',
         formatter:function (value,row,index){
             return '<a href="#" onclick="RoportDetail(\''+row.ReportName+'\')" style="color:#017bce;cursor:hand;cursor:pointer;text-decoration:underline">'+row.ReportName+'</a>'}	 
	     },{
	     field:'ReportClass',
	     title:'报表分类',
	     width:100,
		 align:'center',
		 halign:'center',
		 formatter:comboboxFormatter,
		 editor:{
			 type:'combobox',
			 options:{
				 valueField:'rowid',
				 textField:'name',
				 data:[
				 {rowid:'1',name:'内置报表'},
				 {rowid:'2',name:'自定义'}],
				 }}
	     },{
		 field:'ReortStatus',
         title:'报表状态',
         width:80,
		 align:'center',
		 halign:'center',
		 },{
	     field:'IsStop',
	     title:'是否停用',
	     width:80,
	     align:'center',
	     halign:'center',
	     editor:{type:'checkbox',options:{on:'1',off:'0'}},
	     formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },

	     },{
		 field:'IsRepMonth',
		 title:'月报',
		 width:80,
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },
         editor:{type:'checkbox',options:{on:'1',off:'0'}}
		 },{
		 field:'IsRepSeason',
		 title:'季报',
		 width:80, 
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },
		 editor:{type:'checkbox',options:{on:'1',off:'0'}}
		 },{
	     field:'IsRepHalf',
	     title:'半年报',
	     width:80,
	     align:'center',
	     halign:'center',
	     formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },
		 editor:{type:'checkbox',options:{on:'1',off:'0'}}
	     },{
		 field:'IsRepYear',
		 title:'年报',
		 width:80,
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
						}else{
							return '<input type="checkbox" value="" onclick="return false"/>';
						}  
                    },
		 editor:{type:'checkbox',options:{on:'1',off:'0'}}
	     },{
	     field:'LinkFile',
	     title:'说明文档',
	     width:150,
	     align:'center',
	     halign:'center',
	     formatter:function(value,row,index){
		    return '<a href="#" class="SpecialClass"  title="附件" data-options="iconCls:\'icon-attachment\'" onclick=attachment('+index+')></a>'}

		 }]]
		 
	var MainObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uReportTemplet",
            MethodName:"List",
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        rownumbers:true,//行号
        singleSelect: true, 
        nowrap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onLoadSuccess:function(data){
            if(data){
                $('.SpecialClass').linkbutton({
                    plain:true
                })
            }
        }

        //onClickRow:onClickRow,
        });	 
		 
  // 查询 
  $("#FindBtn").click(function(){
	    var ReportCode   = $('#ReportCodeBox').val()
        var ReportName   = $('#ReportNameBox').val()
     
        MainObj.load({
                ClassName: "herp.budg.hisui.udata.uReportTemplet",
                MethodName: "List",
                ReportCode : ReportCode,
                ReportName : ReportName,
                hospid: hospid
            })});
            		 
//生成报表数据		 
  $("#MakeBtn").unbind('click').click(function(){
       MakeData(hospid); 
       		 
  })	 
}