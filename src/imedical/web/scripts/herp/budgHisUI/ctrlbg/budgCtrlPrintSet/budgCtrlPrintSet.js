var hospid = session['LOGON.HOSPID'];

$(function(){//��ʼ��
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
	     title:'ģ�����',
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
		 title:'ģ������',
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
	     title:'ÿҳ��ӡ��',
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
         title:'�ϱ߾�',
         width:65,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}  ///console.log
		 },{
		 field:'LeftDistance',
         title:'��߾�',
         width:65,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'RightDistance',
         title:'�ұ߾�',
         width:65,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'BottDistance',
         title:'�±߾�',
         width:65,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
	     field:'PaperDirection',
	     title:'ֽ�ŷ���',
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
				 {rowid:'1',name:'����'},
				 {rowid:'2',name:'����'}]
				 }}
	     },{
		 field:'PaperWidth',
		 title:'ֽ�ſ��',
		 width:70,
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
		 field:'PaperHeight',
		 title:'ֽ�Ÿ߶�',
		 width:70, 
		 align:'center',
		 halign:'center',
		 editor:{type:'text'}
		 },{
	     field:'RowsHeight',
	     title:'�и�',
	     width:70,
	     align:'center',
	     halign:'center',
	     editor:{type:'text'}
	     },{
		 field:'IsCurrSet',
		 title:'�Ƿ�ǰģ��',
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
				 {rowid:'1',name:'��'},
				 {rowid:'0',name:'��'}]
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
        	fitColumns: false,//�й̶�
        	loadMsg:"���ڼ��أ����Եȡ�",
        	autoRowHeight: true,
        	autoSizeColumn:true, //�����еĿ������Ӧ����
        	rownumbers:true,//�к�
        	singleSelect: true, 
        	nowrap : true,//��ֹ��Ԫ���е������Զ�����
        	pageSize:20,
        	pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        	pagination:true,//��ҳ
        	fit:true,
        	columns:MainColumns,
        	onClickRow:onClickRow,
        	toolbar: '#tb',
     });
     
   ///�е���¼�����    
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
			
	///ɾ������
	 $("#DelBn").click(function() {
		 var rowid = $('#MainGrid').datagrid("getSelected").rowid;
		 $.messager.confirm('ȷ��','ȷ��ɾ����ѡ������',function(t){
			 if(t){
		 $.m({
			 ClassName:'herp.budg.hisui.udata.uCtrlPrintSet',
             MethodName:'Delete',
             rowid : rowid
             },
             function(SQLCODE){
	             $.messager.progress({
                 title: '��ʾ',
                 msg: '����ɾ�������Ժ򡭡�'
                 });
                 if(SQLCODE==0){
	                 $.messager.popover({
		                 msg: 'ɾ���ɹ���',
		                 type:'success',
                  		 style:{"position":"absolute","z-index":"9999",
                  				left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                  				top:1}});
                  	 $.messager.progress('close');
                  	 $("#MainGrid").datagrid("reload");
                  	 $("#DetailGrid").datagrid("reload");
                 }else{
	                 $.messager.popover({
		                 msg: 'ɾ��ʧ�ܣ�'+SQLCODE,
		                 type:'error',
		                 style:{"position":"absolute","z-index":"9999",
		                 		left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                 		top:1}})
		             $.messager.progress('close');
		             }
		      })
			 }})
	 })
  ///���溯��
  	function saveFn(methodname,data){
	  $.m({
		  ClassName:'herp.budg.hisui.udata.uCtrlPrintSet',
		  MethodName:methodname,
		  data:data
		  },
		  function(SQLCODE){
			  if(SQLCODE==0){
				  $.messager.popover({
					  msg: '����ɹ���',
					  type:'success',
					  style:{"position":"absolute","z-index":"9999",
					         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					         top:1}});
			      $.messager.progress('close');
			      $('#MainGrid').datagrid("reload");
			      editIndex = undefined;
			  }else{
				  $.messager.popover({
					  msg: '����ʧ��!'+SQLCODE,
					  type:'error',
					  style:{"position":"absolute","z-index":"9999",
					         left:-document.body.scrollTop - document.documentElement.scrollTop/2,
					         top:1}
				   })
				  $.messager.progress('close'); 
		 }})}
  
  ///��ѯ����¼� 
  $("#MainFindBtn").click(function(){
	    var Code   = $('#CodeBox').val()
        var Name   = $('#NameBox').val()
     
        MaintableObj.load({
                ClassName: "herp.budg.hisui.udata.uCtrlPrintSet",
                MethodName: "List",
                Code:Code, 
            	Name:Name
            })});
          


//����һ�е���¼�
  $("#AddBn").click(function(){
	  if (endEditing()){
		  $('#MainGrid').datagrid('appendRow',{}); 
		  editIndex = $('#MainGrid').datagrid('getRows').length-1;
		  $('#MainGrid').datagrid('selectRow',editIndex).datagrid('beginEdit', editIndex)}})

//�������¼�
  $("#SaveBn").click(function(){
	  	 $('#MainGrid').datagrid('endEdit', editIndex);
	     $.messager.confirm('ȷ��','ȷ��Ҫ����ѡ����������',function(t){
		     if(t){ 
		     var rows = $('#MainGrid').datagrid("getChanges");
		 
		     if(rows.length==0){
			     $.messager.popover({
				     msg:'û����Ҫ����ļ�¼��',
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
				             msg: 'ģ����벻��Ϊ��',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
					 if(!row.Name){
			             $.messager.popover({
				             msg: 'ģ�����Ʋ���Ϊ��',
						     type:'alert',
				             style:{"position":"absolute","z-index":"9999",
	        		                left:-document.body.scrollTop - document.documentElement.scrollTop/2,
	        		                top:1}
						        	})
						        	return;
						        }
                     
		              $.messager.progress({
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	                  })
	                  if(!row.rowid){//����
	                        var data=Code+"|"+Name+"|"+RowDataNum
	                           +"|"+TopDistance+"|"+LeftDistance+"|"+RightDistance
	                           +"|"+BottDistance+"|"+PaperDirection+"|"+PaperWidth+"|"+PaperHeight
	                           +"|"+RowsHeight+"|"+IsCurrSet;
	                        saveFn('Insert',data);
		               }else{//�������޸�
		                   var data2=rowid+"|"+Code+"|"+Name+"|"+RowDataNum
	                           +"|"+TopDistance+"|"+LeftDistance+"|"+RightDistance
	                           +"|"+BottDistance+"|"+PaperDirection+"|"+PaperWidth+"|"+PaperHeight
	                           +"|"+RowsHeight+"|"+IsCurrSet;
		              	    saveFn('Update',data2);		
						}
					 editIndex = undefined;
					 $("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
	                 }
	          }else{
		          return;
		          }
	     }})
	  })

}