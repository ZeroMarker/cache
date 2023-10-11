
var SId=getParam("SAAId");
var AuthorArr=[];
$(function(){
	initPage();
	initMethod();
})

function initPage(){
	runClassMethod("web.DHCEMSysItmAut","ListIsWhich",{'SID':SId},function(jsonData){ 
		if(jsonData.length){
			AuthorArr = jsonData;
			for (i in jsonData){
				var thisItm=jsonData[i];
				$('input[name="secflag"][value="'+thisItm.value+'"]').attr("checked","checked")
			}	
		}
	},"json",false);

}

function initMethod(){
	$("#saveBtn").on('click',function(){
		saveSecFlag();  	     
	});
}



//保存授权类型  add liyarong 2017-03-01
function saveSecFlag(){
	var secflags ="";
	
	$("input[name='secflag']:checked").each(function(){
		secflags+=(secflags?"#":"")+this.value;
	});	
	
	var outAuthor="",outAuthorTip="";
	for (i in AuthorArr){
		var thisItm=AuthorArr[i];
		if(secflags.indexOf(thisItm.value)==-1){
			outAuthor+=(outAuthor?"#":"")+thisItm.value;
			outAuthorTip+=(outAuthorTip?",":"")+thisItm.text;
		}
	}
	
	var param=secflags+"$"+SId+"$"+outAuthor;
	if(outAuthorTip!=""){
		parent.$.messager.confirm('提示', '移除了授权类型【'+outAuthorTip+'】!继续保存会【自动移除】以上类型的授权数据,是否继续?', function(r){
		    if (r){
		    	save(param);
			}
		});	
	}else{
		save(param);	
	}
	return;   
}

function save(param){
	runClassMethod("web.DHCEMSysItm","updFlag",{'params':param},function(data){ 
		if(data==0){
			parent.$.messager.alert('提示',"保存成功");	
			$("#datagrid").datagrid('load')
			$("#datagrid2").datagrid('load')
			parent.$('#queryBTN').click();
			parent.$("#sysWin").window('close');		
		}else{
			if(data="null"){
				parent.$.messager.alert('提示',"未选类型保存失败");
		    }else{
			    parent.$.messager.alert('提示',"保存失败");
			    parent.$("#sysWin").window('close');
			}	
		}
	});	
}