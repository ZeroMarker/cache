var hospid = session['LOGON.HOSPID'];

$(function(){//初始化
    Initmain();
    $('#ReportCodeBox').val('')
    $('#ReportNameBox').val('')
}); 
 
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
	     width:70,
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
				 {rowid:'2',name:'自定义'}]
				 }}
	     },{
		 field:'ReortStatus',
         title:'报表状态',
         width:65,
		 align:'center',
		 halign:'center'
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
                    }
	     },{
		 field:'IsRepMonth',
		 title:'月报',
		 width:40,
		 align:'center',
		 halign:'center',
		 formatter: function (value) {
					    if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
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
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
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
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
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
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
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
		 halign:'center'
		 },{
	     field:'StopYearMonth',
	     title:'停用年月',
	     width:90,
	     align:'center',
	     halign:'center'
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
	     width:100,
		 align:'left',
		 halign:'left'
	     },{
		 field:'CheckDate',
		 title:' 审核时间',
		 width:90,
		 align:'center',
		 halign:'center'
		 },{
		 field:'StopDesc',
		 title:'停用原因',
		 width:80,
		 align:'left',
		 halign:'left'
		 },{
	     field:'stoper',
	     title:'停用人',
	     width:80,
		 align:'left',
		 halign:'left'
	     },{
		 field:'stopDate',
		 title:'停用时间',
	     width:90,
		 align:'center',
		 halign:'center'
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
        onClickRow:onClickRow,
        toolbar: '#tb',
        onLoadSuccess:function(data){
            if(data){$('.SpecialClass').linkbutton({plain:true})}
            }
     });
     
    ///行点击事件函数    
        var editIndex = undefined;
        function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#MainGrid').datagrid('validateRow', editIndex)){
				$('#MainGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
        function onClickRow(index){
	        $('#MainGrid').datagrid('endEdit', editIndex);
	        var row = $('#MainGrid').datagrid('getSelected');
	        $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uReportTemplet",
                MethodName:"DetailList",
                ReportTempletID : row.rowid  
            });
	        if(row.ReortStatus=="审核"){
	                  return;
	        }else{
			if (editIndex != index){
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index)
					$('#MainGrid').datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex)}
			}}}
			
	 ///删除函数
	 function deleteFn(rowid){
		 $.m({
			 ClassName:'herp.budg.hisui.udata.uReportTemplet',
             MethodName:'Delete',
             rowid : rowid
             },
             function(SQLCODE){
	             $.messager.progress({
                 title: '提示',
                 msg: '正在删除，请稍候……'
                 });
                 if(SQLCODE==0){
	                 $.messager.popover({
		                 msg: '删除成功！',
		                 type:'success',
                  		 style:{"position":"absolute","z-index":"9999",
                  				left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                  				top:1}});
                  	 $.messager.progress('close');
                  	 $("#MainGrid").datagrid("reload");
                  	 $("#DetailGrid").datagrid("reload");
                 }else{
	                 $.messager.popover({
		                 msg: '删除失败！'+SQLCODE,
		                 type:'error',
		                 style:{"position":"absolute","z-index":"9999",
		                 		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                 		top:1}})
		             $.messager.progress('close');
		             }
		      })
		 } 
  ///保存函数
  function saveFn(methodname,data){
	  $.m({
		  ClassName:'herp.budg.hisui.udata.uReportTemplet',
		  MethodName:methodname,
		  data:data
		  },
		  function(SQLCODE){
			  if(SQLCODE==0){
				  $.messager.popover({
					  msg: '保存成功！',
					  type:'success',
					  style:{"position":"absolute","z-index":"9999",
					         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					         top:1}});
			      $.messager.progress('close');
			      $('#MainGrid').datagrid("reload");
			      editIndex = undefined;
			  }else{
				  $.messager.popover({
					  msg: '保存失败'+SQLCODE,
					  type:'error',
					  style:{"position":"absolute","z-index":"9999",
					         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					         top:1}
				   })
				  $.messager.progress('close'); 
		 }})}
  
  ///查询点击事件 
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
          

///删除点击事件
  $("#DelBn").click(function() {
     var row = $('#MainGrid').datagrid('getSelected');
     if(row == null){
         $.messager.popover({
             msg:'请选择所要删除的行！',
             timeout: 2000,type:'alert',
             showType: 'show',
             style:{"position":"absolute","z-index":"9999",
                      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                      top:1}}); 
         return;
    }else if(row.ReortStatus=="审核"){
         $.messager.popover({
               msg:'此报表已审核，不可删除！',
               timeout: 2000,type:'alert',
               showType: 'show',
               style:{"position":"absolute","z-index":"9999",
                      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                      top:1}}); 
               return;
     }else{
         var rowDetail = $('#DetailGrid').datagrid('getRows').length;
         var rowid = row.rowid;
         if((rowDetail>0)&&(rowid>0)){
             $.messager.confirm('确定','此报表含有明细，确认删除吗？',function(t){
                 if(t){
                     deleteFn(rowid);
                    }
                })
        }else{
            $.messager.confirm('确定','确认删除吗？',function(t){
                if(t){
                    if(rowid>0){
                        deleteFn(rowid);
                    }else{
                        editIndex= $('#MainGrid').datagrid('getRows').length-1;
                        $('#MainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
                    }
                }
                })}
           }})

//新增一行点击事件
  $("#AddBn").click(function(){
	  if (endEditing()){
		  $('#MainGrid').datagrid('appendRow',{ReortStatus:"新建"}); 
		  editIndex = $('#MainGrid').datagrid('getRows').length-1;
		  $('#MainGrid').datagrid('selectRow',editIndex).datagrid('beginEdit', editIndex)}})

//保存点击事件
  $("#SaveBn").click(function(){
	  var indexs = $('#MainGrid').datagrid('getEditingRowIndexs');
	  if (indexs.length > 0) {
		  for (i = 0; i < indexs.length; i++) {
			  var ed = $('#MainGrid').datagrid('getEditor', {
				  index: indexs[i],
				  field: 'BudgReportTempletSID'
				  });
			   if (ed) {
				   var BudgReportTempletSName = $(ed.target).combobox('getText');
				   $('#MainGrid').datagrid('getRows')[indexs[i]]['BudgReportTempletSName'] = BudgReportTempletSName;
						 }
	           $('#MainGrid').datagrid('endEdit', indexs[i]);
			     }}
	  
	 //alert(editIndex);
	     $.messager.confirm('确定','确定要保存选定的数据吗？',function(t){
		     if(t){ 
		     var rows = $('#MainGrid').datagrid("getChanges");
		     if(rows.length==0){
			     $.messager.popover({
				     msg:'没有需要保存的记录！',
				     timeout: 2000,type:'alert',
				     showType: 'show',
				     style:{"position":"absolute","z-index":"9999",
				           left:-document.body.scrollTop - document.documentElement.scrollTop/2,
				           top:1}})
				           return;
			    }	  
		     if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i]; 
		              var rowid= row.rowid;
		              var ReportCode=((row.ReportCode==undefined)?'':row.ReportCode);
		              var ReportName=((row.ReportName==undefined)?'':row.ReportName);
		              var ReportClass=((row.ReportClass==undefined)?'':row.ReportClass);
		              var IsRepMonth=((row.IsRepMonth==undefined)?'':row.IsRepMonth);
		              var IsRepSeason=((row.IsRepSeason==undefined)?'':row.IsRepSeason);
		              var IsRepHalf=((row.IsRepHalf==undefined)?'':row.IsRepHalf);
		              var IsRepYear=((row.IsRepYear==undefined)?'':row.IsRepYear);
		              var ColGroupNo=((row.ColGroupNo==undefined)?'':row.ColGroupNo);
		              var startYearMonth=((row.startYearMonth==undefined)?'':row.startYearMonth);
		              var StopYearMonth=((row.StopYearMonth==undefined)?'':row.StopYearMonth);
		              var BudgReportTempletSID=((row.BudgReportTempletSID==undefined)?'':row.BudgReportTempletSID);
		              //alert(ReportCode);
		             if(!row.ReportCode){
			             $.messager.popover({
				             msg: '报表编码不能为空',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
					 if(!row.ReportName){
			             $.messager.popover({
				             msg: '报表名称不能为空',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
                     
		              $.messager.progress({
	                      title: '提示',
	                      msg: '正在保存，请稍候……'
	                  })
	                  if(!row.rowid){//新增
	                        var data=hospid+"|"+ReportCode+"|"+ReportName+"|"+ReportClass
	                           +"|"+0+"|"+IsRepMonth+"|"+IsRepSeason
	                           +"|"+IsRepHalf+"|"+IsRepYear+"|"+ColGroupNo+"|"+BudgReportTempletSID;
	                        saveFn('Insert',data);
		               }else{//行数据修改
		                    var data2=hospid+"|"+ReportCode+"|"+ReportName+"|"+ReportClass
		                       +"|"+IsRepMonth+"|"+IsRepSeason
		              	       +"|"+IsRepHalf+"|"+IsRepYear+"|"+ColGroupNo+"|"+BudgReportTempletSID+"|"+rowid;
		              	    saveFn('Update',data2);		
						}
					 editIndex = undefined;
					 $("#MainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
	                 }
	          }else{
		          return;
		          }
	     }})
	  })

}