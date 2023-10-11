var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
$(function(){//初始化
    Init();
    $('#ReportCodeBox').val('')
    $('#ReportNameBox').val('')
}); 
 
function Init(){  
	MainColumns=[[{
	     field:'Manipulate',
	     title:'操作',
	     width:140,
	     align:'center',
	     halign:'center',
	     formatter:function(value,row,index){
		    return '<a href="#" class="SpecialClass" title="审核" data-options="iconCls:\'icon-stamp\'"  onclick=stamp('+index+') ></a>'
        + '<a href="#" class="SpecialClass" title="取消审核" data-options="iconCls:\'icon-stamp-cancel\'" onclick=stampcancel('+index+') ></a>'
        + '<a href="#"  class="SpecialClass" title="启用" data-options="iconCls:\'icon-run\'" onclick=start('+index+')></a>'
        + '<a href="#"  class="SpecialClass" title="停用" data-options="iconCls:\'icon-unuse\'" onclick=stop('+index+')></a>'}
	     },{
	     field:'ReportTempletID',
	     hidden: true
	     },{
	     field:'CompDR',
	     hidden: true
	     },{
	     field:'ReportCode',
	     title:'报表编码',
	     width:70,
	     allowBlank:false,
	     required:true,
	     align:'left',
	     halign:'left',
	     editor:{
		     type:'validatebox',
		     options:{
			     required:true}}
	     },{
		 field:'ReportName',
		 title:'报表名称',
		 width:150,
		 align:'left',
		 allowBlank:false,
		 required:true,
		 halign:'left',
		 editor:{
			 type:'validatebox',
			 options:{
			     required:true}}
		 },{
	     field:'ReportClass',
	     title:'报表分类',
	     width:65,
		 align:'left',
		 halign:'left',
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
         width:65,
		 align:'center',
		 halign:'center',
		 },{
	     field:'IsStop',
	     title:'是否停用',
	     width:65,
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
		 width:40,
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
		 width:40, 
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
	     width:54,
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
		 width:40,
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
		 field:'ColGroupNo',
		 title:'纵项组数',
	     width:70,
	     align:'center',
	     halign:'center',
	     editor:{type:'text'}
		 },{
		 field:'startYearMonth',
		 title:' 启用年月',
		 width:90,
		 align:'center',
		 halign:'center',
		 },{
	     field:'StopYearMonth',
	     title:'停用年月',
	     width:90,
	     align:'center',
	     halign:'center',
	     },{
	     field:'BudgReportTempletSID',
	     title:'原报表',
	     width:150,
	     align:'left',
	     halign:'left',
	     formatter:function(value,row,index){
				return row.BudgReportTempletSName;
			},
		 editor:{
			 type:'combobox',
			 options:{
				 valueField:'rowid',
				 textField:'name',
				 mode:'remote',
				 url:$URL+"?ClassName=herp.budg.hisui.udata.uReportTemplet&MethodName=ListFundType",
				 delay:200,
				 onBeforeLoad:function(param){
					 var row=$('#MainGrid').datagrid('getSelected')
					 if(row.rowid==undefined){row.rowid=0}
			      param.str = param.q;
			      param.rowid=row.rowid
	                    	}}}
	     },{
	     field:'LinkFile',
	     title:'说明文档',
	     width:70,
	     align:'center',
	     halign:'center',
	     formatter:function(value,row,index){
		    return '<a href="#" class="SpecialClass"  title="附件" data-options="iconCls:\'icon-attachment\'" onclick=attachment('+index+')></a>'}
	     },{
	     field:'Checker',
	     title:'审核人',
	     width:50,
		 align:'left',
		 halign:'left',
	     },{
		 field:'CheckDate',
		 title:' 审核时间',
		 width:90,
		 align:'center',
		 halign:'center',
		 },{
		 field:'StopDesc',
		 title:'停用原因',
		 width:80,
		 align:'left',
		 halign:'left',
		 },{
	     field:'stoper',
	     title:'停用人',
	     width:80,
		 align:'left',
		 halign:'left',
	     },{
		 field:'stopDate',
		 title:'停用时间',
	     width:90,
		 align:'center',
		 halign:'center',
		 }]]
		 
	
		 
	var MaintableObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uReportTemplet",
            MethodName:"List",
            hospid: hospid
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
        split:true,
        onClickRow:onClickRow,
        toolbar: '#tb',
        onLoadSuccess:function(data){
            if(data){
                $('.SpecialClass').linkbutton({
                    plain:true
                })
            }
        }
        });
            
    ///行点击事件
    function onClickRow(index){
	    var row = $('#MainGrid').datagrid('getSelected');
            $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uReportTemplet",
                MethodName:"DetailList",
                ReportTempletID : row.rowid  
            }); 
	        }
	            
   ///审核功能
   stamp=function (index) {
	   $('#MainGrid').datagrid('selectRow',index);
	   onClickRow(index);
	   var row = $('#MainGrid').datagrid('getSelected');
	   if(row.ReortStatus=="审核"){
		   $.messager.popover({
		        msg:'该报表已为审核状态！',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
        }else{
	        $.messager.confirm('确认', '审核后不可再编辑，是否确定？', function(t){
		        
		        if(t){
			        $.m({
			        	ClassName:'herp.budg.hisui.udata.uReportTemplet',
			        	MethodName:'stampornot',
			        	rowid : row.rowid,
			        	ReortStatus : 1,
			        	Checker:userid,
			        	CheckDate:""
					          },
				function(SQLCODE){
					$.messager.progress({
	                      title: '提示',
	                      msg: '正在审核，请稍候……'
	                  });
	                  if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: '审核成功！',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        $.messager.progress('close');
		                $("#MainGrid").datagrid("reload");
		                } else{
					    $.messager.popover({
						    msg: '审核失败！'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}})
						    $.messager.progress('close');
						    }  
		      })
			        }})}
	   }    
 ///取消审核       
    stampcancel=function (index) {
	   $('#MainGrid').datagrid('selectRow',index);
	   onClickRow(index);
	   var row = $('#MainGrid').datagrid('getSelected');
	   if(row.ReortStatus=="新建"){
		   $.messager.popover({
		        msg:'该报表非审核状态，无需取消！',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
        }else{
	        $.messager.confirm('确认', '确定取消审核吗？', function(t){
		        if(t){
			        $.m({
			        	ClassName:'herp.budg.hisui.udata.uReportTemplet',
			        	MethodName:'stampornot',
			        	rowid : row.rowid,
			        	ReortStatus : 0,
			        	Checker:userid,
			        	CheckDate:""
					          },
				function(SQLCODE){
					$.messager.progress({
	                      title: '提示',
	                      msg: '正在审核，请稍候……'
	                  });
	                  if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: '审核成功！',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        $.messager.progress('close');
		                $("#MainGrid").datagrid("reload");
		                } else{
					    $.messager.popover({
						    msg: '审核失败！'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}})
						    $.messager.progress('close');
						    }  
		      })	 
			        }})}
	   }    
            
///启用           
    start=function (index) {
	   $('#MainGrid').datagrid('selectRow',index);
	   onClickRow(index);
	   var row = $('#MainGrid').datagrid('getSelected');
	   if(row.IsStop==0){
		   $.messager.popover({
		        msg:'该报表已启用！',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
        }else{
	        $.messager.confirm('确认', '确认启用吗？', function(t){
		        if(t){
			        $.m({
			        	ClassName:'herp.budg.hisui.udata.uReportTemplet',
			        	MethodName:'start',
			        	rowid : row.rowid,
			        	isstop : 0,
			        	startYearMonth :""
					          },
				function(SQLCODE){
					$.messager.progress({
	                      title: '提示',
	                      msg: '正在启用，请稍候……'
	                  });
	                  if(SQLCODE==0){
			        	$.messager.popover({
				        	msg: '启用成功！',
				        	type:'success',
				        	style:{"position":"absolute","z-index":"9999",
				        	left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				        	top:1}});
				        $.messager.progress('close');
		                $("#MainGrid").datagrid("reload");
		                } else{
					    $.messager.popover({
						    msg: '启用失败！'+SQLCODE,
						    type:'error',
						    style:{"position":"absolute","z-index":"9999",
						    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
						    top:1}})
						    $.messager.progress('close');
						    }  
		      })
			        }})}
	   }
	    
	   //停用   
      stop=function (index) {
	   $('#MainGrid').datagrid('selectRow',index);
	   onClickRow(index);
	   var row = $('#MainGrid').datagrid('getSelected');
	   if(row.IsStop==1){
		   $.messager.popover({
		        msg:'该报表已停用！',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:1}}); 
                return;
        }else{
	       Stopreason(row,userid);
        }}
        
     // 查询 
  $("#MainFindBtn").click(function(){
	    var ReportCode   = $('#ReportCodeBox').val()
        var ReportName   = $('#ReportNameBox').val()
     
        MaintableObj.load({
                ClassName: "herp.budg.hisui.udata.uReportTemplet",
                MethodName: "List",
                ReportCode : ReportCode,
                ReportName : ReportName,
                hospid: hospid
            })}); 
}