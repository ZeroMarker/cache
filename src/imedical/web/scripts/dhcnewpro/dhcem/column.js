$(function(){ 

	$("#datagrid").datagrid(
	{
		url:'dhcapp.broker.csp?ClassName=web.DHCEMColumn&MethodName=queryColumn&cspName='+pCspName+'&tableId='+pTableId+'&column='+pColumn+"&menuId="+pMenuId,	
		onLoadSuccess:function(data){
			if(data.rows[0].SGSSaveFor=="D"){
				$("#saveTypeRadio1").attr("checked","checked");
			}
			if(data.rows[0].SGSSaveFor=="G"){
				$("#saveTypeRadio2").attr("checked","checked");
			}
			if(data.rows[0].SGSSaveFor=="U"){
				$("#saveTypeRadio3").attr("checked","checked");
			}
		}
	})
});

function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function move(isUp,index) {

		var rows=$('#datagrid').datagrid('getData')

		if((isUp)&&(index==0)){
			return;
		}
		if(!(isUp)&&(index==rows.length)){
			return;
		}

		
		var $view = $('div.datagrid-view');
		var $row = $view.find('tr[datagrid-row-index=' + index + ']');		
	    if (isUp) {
	            $row.each(function(){
	                    var prev = $(this).prev();
	                    prev.length && $(this).insertBefore(prev);
	    });
	    } else {
	            $row.each(function(){
	                    var next = $(this).next();
	                   next.length && $(this).insertAfter(next);
	            });
	    }
}
function moveUp(index){move(true,index)}
function moveDown(index){move(false,index)}
function cellStyler(value,row,index){
	if(value==undefined){   //2016-07-18 qunianpeng
		value="" ;
	}	
	html="<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveUp("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-arrow_up l-btn-icon-left'>上移</span></span>"
	html=html+"</a>"
	html=html+"<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveDown("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='l-btn-text icon-arrow_down l-btn-icon-left'>下移</span></span>"
	html=html+"</a>"+value
	return html;
}


function save(){
	 if(!endEditing("#datagrid")){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	 }
	
      type=$("input[name=saveTypeRadio]:checked").val();
      pointer="DHC"
      if(type=="G"){
	  	 pointer=LgGroupID   
	  }
	  if(type=="U"){
	     pointer=LgUserID
	  }
	  	
	 var ParArr=[];	
	 var $row = $('.datagrid-view2 > .datagrid-body').find('tr');
	 
	 $row.each(function(i,obj){
			
		SGSName=getValueByField(obj,"SGSName");
		SGSWidth=getValueByField(obj,"SGSWidth");
		SGSAlignment=getValueByField(obj,"SGSAlignment");
		SGSHidden=getValueByField(obj,"SGSHidden");
		SGSKey=getValueByField(obj,"SGSKey");
		var item=new Object();
		item.SGSName=SGSName;
		item.SGSWidth=SGSWidth;
		item.SGSAlignment=SGSAlignment;
		item.SGSHidden=SGSHidden;
		item.SGSKey=SGSKey;
		item.SGSOrderNum=i+1;     
	  	ParArr.push(JSON.stringify(item))
	       
	 });

		  runClassMethod(
			"web.DHCEMColumn",
			"saveTable",
			{
				jsonStr:ParArr.join("$$"),
				cspName:pCspName,
				tableId:pTableId,
				menuId:pMenuId,
				type:type,
				pointer:pointer
			},function(ret){
				if(ret==0){
					window.parent.dhccBox.message({
						 message : '操作成功!'
					})
					var index = parent.layer.getFrameIndex(window.name);
					window.parent.layer.close(index)					
				}else{
					dhccBox.alert(ret);	
				}
			},"text") 	
	
}
function getValueByField(obj,field){		
	 ret=""  
	 $(obj).find('td').each(function(j,o){
		 	if($(o).attr("field")==field){
				ret=$(o).find('div').html(); 	
			}
	 });
	 return ret;
}
