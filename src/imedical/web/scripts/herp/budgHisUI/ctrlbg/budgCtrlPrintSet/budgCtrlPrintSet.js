var hospid = session['LOGON.HOSPID'];

$(function(){//初始化
    Initmain();
    $('#CodeBox').val("");
    $('#NameBox').val("");
}); 
 
function Initmain(){
	MainColumns=[[{
	     field:'rowid',
	     hidden: true
	     },{
	     field:'Code',
	     title:'模板编码',
	     width:70,
	     allowBlank:false,
	     align:'left',
	     halign:'left',
	     editor:{
		     type:'validatebox',
		     options:{
			     required:true}}
	     },{
		 field:'Name',
		 title:'模板名称',
		 width:150,
		 align:'left',
		 allowBlank:false,
		 halign:'left',
		 editor:{
			 type:'validatebox',
			 options:{
			     required:true}}
		 },{
	     field:'RowDataNum',
	     title:'每页打印数',
	     width:100,
	     allowBlank:false,
		 align:'center',
		 halign:'center',
		 editor:{
			 type:'validatebox',
			 options:{
			     required:true}}
		 },{
		 field:'TopDistance',
         title:'上边距',
         width:65,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}  ///console.log
		 },{
		 field:'LeftDistance',
         title:'左边距',
         width:65,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'RightDistance',
         title:'右边距',
         width:65,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'BottDistance',
         title:'下边距',
         width:65,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
	     field:'PaperDirection',
	     title:'纸张方向',
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
				 {rowid:'1',name:'纵向'},
				 {rowid:'2',name:'横向'}]
				 }}
	     },{
		 field:'PaperWidth',
		 title:'纸张宽度',
		 width:70,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'PaperHeight',
		 title:'纸张高度',
		 width:70, 
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
	     field:'RowsHeight',
	     title:'行高',
	     width:70,
	     align:'center',
	     halign:'center',
	     editor:{type:'text'}
	     },{
		 field:'IsCurrSet',
		 title:'是否当前模板',
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
				 {rowid:'1',name:'是'},
				 {rowid:'0',name:'否'}]
				 }}
		 }]]
		 
		var MaintableObj = $HUI.datagrid("#MainGrid",{
        	url:$URL,
       		queryParams:{
            	ClassName:"herp.budg.hisui.udata.uCtrlPrintSet",
            	MethodName:"List",
            	Code:"", 
            	Name:""
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
			if (editIndex != index){
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index)
					$('#MainGrid').datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex)}
			}}
			
	///删除操作
	 $("#DelBn").click(function() {
		 var rowid = $('#MainGrid').datagrid("getSelected").rowid;
		 $.messager.confirm('确定','确定删除所选数据吗？',function(t){
			 if(t){
		 $.m({
			 ClassName:'herp.budg.hisui.udata.uCtrlPrintSet',
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
			 }})
	 })
  ///保存函数
  	function saveFn(methodname,data){
	  $.m({
		  ClassName:'herp.budg.hisui.udata.uCtrlPrintSet',
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
					  msg: '保存失败!'+SQLCODE,
					  type:'error',
					  style:{"position":"absolute","z-index":"9999",
					         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					         top:1}
				   })
				  $.messager.progress('close'); 
		 }})}
  
  ///查询点击事件 
  $("#MainFindBtn").click(function(){
	    var Code   = $('#CodeBox').val()
        var Name   = $('#NameBox').val()
     
        MaintableObj.load({
                ClassName: "herp.budg.hisui.udata.uCtrlPrintSet",
                MethodName: "List",
                Code:Code, 
            	Name:Name
            })});
          


//新增一行点击事件
  $("#AddBn").click(function(){
	  if (endEditing()){
		  $('#MainGrid').datagrid('appendRow',{}); 
		  editIndex = $('#MainGrid').datagrid('getRows').length-1;
		  $('#MainGrid').datagrid('selectRow',editIndex).datagrid('beginEdit', editIndex)}})

//保存点击事件
  $("#SaveBn").click(function(){
	  	 $('#MainGrid').datagrid('endEdit', editIndex);
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
		    	if(rows.length>0){  ///console.log
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i]; 
		              var rowid= row.rowid;
		              var Code=((row.Code==undefined)?'':row.Code);
		              var Name=((row.Name==undefined)?'':row.Name);
		              var RowDataNum=((row.RowDataNum==undefined)?'':row.RowDataNum);
		              var TopDistance=((row.TopDistance==undefined)?'':row.TopDistance);
		              var LeftDistance=((row.LeftDistance==undefined)?'':row.LeftDistance);
		              var RightDistance=((row.RightDistance==undefined)?'':row.RightDistance);
		              var BottDistance=((row.BottDistance==undefined)?'':row.BottDistance);
		              var PaperDirection=((row.PaperDirection==undefined)?'':row.PaperDirection);
		              var PaperWidth=((row.PaperWidth==undefined)?'':row.PaperWidth);
		              var PaperHeight=((row.PaperHeight==undefined)?'':row.PaperHeight);
		              var RowsHeight=((row.RowsHeight==undefined)?'':row.RowsHeight);
		              var IsCurrSet=((row.IsCurrSet==undefined)?'':row.IsCurrSet);
		             if(!row.Code){
			             $.messager.popover({
				             msg: '模板编码不能为空',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
					 if(!row.Name){
			             $.messager.popover({
				             msg: '模板名称不能为空',
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
	                        var data=Code+"|"+Name+"|"+RowDataNum
	                           +"|"+TopDistance+"|"+LeftDistance+"|"+RightDistance
	                           +"|"+BottDistance+"|"+PaperDirection+"|"+PaperWidth+"|"+PaperHeight
	                           +"|"+RowsHeight+"|"+IsCurrSet;
	                        saveFn('Insert',data);
		               }else{//行数据修改
		                   var data2=rowid+"|"+Code+"|"+Name+"|"+RowDataNum
	                           +"|"+TopDistance+"|"+LeftDistance+"|"+RightDistance
	                           +"|"+BottDistance+"|"+PaperDirection+"|"+PaperWidth+"|"+PaperHeight
	                           +"|"+RowsHeight+"|"+IsCurrSet;
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