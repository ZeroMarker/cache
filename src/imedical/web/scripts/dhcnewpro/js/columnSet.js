$(document).ready(function() {
	
	
	 

    $("input[name=saveTypeRadio]").click(function(){
	  	switch($("input[name=saveTypeRadio]:checked").attr("id")){
		  case "saveTypeRadio1":
		   break;
		  case "saveTypeRadio2":
		   
		   break;
		  case "saveTypeRadio3":
		   
		   break;
		  case "saveTypeRadio3":
		   
		   break; 
		  default:
		   break;
  		}
 	
	});
	$('#table').dhccTable({
        url:'dhcapp.broker.csp?ClassName=web.DHCEMColumn&MethodName=queryColumn&cspName='+pCspName+'&tableId='+pTableId+'&column='+pColumn+"&menuId="+pMenuId,
        singleSelect:true,
        height:$(window).height()-130,
        columns:[
		{field: 'SGSName',title: '列标题',
			editable: {
                type: 'text'
            }
         },
		{field: 'SGSWidth',title: '宽度',
			editable: {
                type: 'text',
                //mode: "inline",
                emptytext:''
            }
        },
		{field: 'SGSAlignment',title: '对齐方式',
			editable: {
                type: "select",
                //mode: "inline",
            	source: [{ value: 'left', text: "left" }, { value: 'center', text: "center" }, { value: 'right', text: "right" }]
            }
        }, 
		{field: 'SGSHidden',title: '是否隐藏',
			editable: {
                //mode: "inline",
                type: "select",              //编辑框的类型。支持text|textarea|select|date|checklist等
            	source: [{ value: 'Y', text: "Y" }, { value: 'N', text: "N" }]
            }
         },
		{field: 'SGSOrderNum',title: '顺序',
			editable: {
                type: 'text',
                mode: "inline"
            }}
		],
		onlyInfoPagination:true,
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
    });
    $("#cancel").on('click',function(){
	    var index = parent.layer.getFrameIndex(window.name);
		window.parent.layer.close(index)
    });   
    $("#save").on('click',function(){
	      
	
	      type=$("input[name=saveTypeRadio]:checked").val();
	      pointer="DHC"
	      if(type=="G"){
		  	 pointer=LgGroupID   
		  }
		  if(type=="U"){
		     pointer=LgUserID
		  }	
		  var rows = $("#table").dhccTableM('getData');
		  ParArr=[];
		  $(rows).each(function(index,item){
			item.ID="";
			item.SGSReference=pointer;
			item.SGSSaveFor=type;     
		  	ParArr.push(JSON.stringify(item) )
		  })
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
					
					
					//$('#table').dhccQuery()
					
					
				}else{
					dhccBox.alert(ret);	
				}
			},"text")  
	})
   
});	