var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
var loadFlag=1;
$(document).ready(function(){
	layui.use(['form','tree'], function(){
		
		
	  var form = layui.form;
	  
	  //监听提交
	  form.on('submit(saveForm)', function(data){
		
		if(data.field.attrStyle.length>50){
			alert("元素style不能超过50个字符")
			return false;
		}  
		id="#"+$("#myID").val()
		newArr=new Array()
		existFlag=1;
		var arr=parent.$(id).parent().find(".view").children().attr("data-add")
		if(arr!=""){
			arrs=arr.split("~")
			for(var i=0;i<arrs.length;i++){
				tmparrs=arrs[i].split("|")
				if(tmparrs[2]==data.field.dicId){
					existFlag=0
					newArr.push("||"+data.field.dicId+"|"+data.field.required+"|"+data.field.printSeq+"|"+data.field.print+"||"+data.field.attrStyle)
				}else{
					newArr.push(arrs[i])
				}	
			}
		}
		if(existFlag==1){
			newArr.push("||"+data.field.dicId+"|"+data.field.required+"|"+data.field.printSeq+"|"+data.field.print+"||"+data.field.attrStyle)
		}
		parent.$(id).parent().find(".view").children().attr("data-add",newArr.join("~"))
		parent.layer.close(index);
	    return false;
	  });
		  
	 
	  runClassMethod(
				"web.DHCADVFormDic",
				"listLayTree",
				{
					'id':$("#parDicId").val()
				},
				function(data){
					
					$("#field").val(data[0].field) 
					$("#title").val(data[0].title)
					$("#style").val(data[0].style)
					id="#"+$("#myID").val()
					var arr=parent.$(id).parent().find(".view").children().attr("data-add")
					$("input[name='required'][value='off']").attr("checked","checked");
					$("input[name='printSeq'][value='off']").attr("checked","checked");
					$("input[name='print'][value='off']").attr("checked","checked");
					//salert(arr)
					if(arr!=""){
						arrs=arr.split("~")
						for(var i=0;i<arrs.length;i++){
							tmparrs=arrs[i].split("|")
							if(tmparrs[2]==$("#dicId").val()){
								if(tmparrs[3]=="on"){
									$("input[name='required'][value='on']").attr("checked","checked");
								}
								if(tmparrs[4]=="on"){
									$("input[name='printSeq'][value='on']").attr("checked","checked");
								}
								if(tmparrs[5]=="on"){
									$("input[name='print'][value='on']").attr("checked","checked");
								}
								$("#attrStyle").val(tmparrs[7])
							}	
						}
					}
					form.render(); 
					layui.tree({
					  elem: '#tree' //传入元素选择器
					  ,nodes: data  
					  ,click: function(node){
						  	$("#dicId").val(node.id)
					    	$("#field").val(node.field) 
							$("#title").val(node.title)
							$("#style").val(node.style)
							id="#"+$("#myID").val()
							$("input[name='required'][value='off']").attr("checked","checked");
							$("input[name='printSeq'][value='off']").attr("checked","checked");
							$("input[name='print'][value='off']").attr("checked","checked");
							arr=parent.$(id).parent().find(".view").children().attr("data-add");
							//alert(arr)
							if(arr!=""){
								arrs=arr.split("~")
								for(var i=0;i<arrs.length;i++){
									tmparrs=arrs[i].split("|")
									if(tmparrs[2]==$("#dicId").val()){
										if(tmparrs[3]=="on"){
											$("input[name='required'][value='on']").attr("checked","checked");
										}
										if(tmparrs[4]=="on"){
											$("input[name='printSeq'][value='on']").attr("checked","checked");
										}
										if(tmparrs[5]=="on"){
											$("input[name='print'][value='on']").attr("checked","checked");
										}
										$("#attrStyle").val(tmparrs[7])
									}	
								}
							}
							form.render();  
					  }  
					});
				})

	});
});


function clearForm(){
	$("input[name='required'][value='on']").attr("checked","");
	$("input[name='printSeq'][value='on']").attr("checked","");
	$("input[name='print'][value='on']").attr("checked","");
}