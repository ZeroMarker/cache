
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



//������Ȩ����  add liyarong 2017-03-01
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
		parent.$.messager.confirm('��ʾ', '�Ƴ�����Ȩ���͡�'+outAuthorTip+'��!��������᡾�Զ��Ƴ����������͵���Ȩ����,�Ƿ����?', function(r){
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
			parent.$.messager.alert('��ʾ',"����ɹ�");	
			$("#datagrid").datagrid('load')
			$("#datagrid2").datagrid('load')
			parent.$('#queryBTN').click();
			parent.$("#sysWin").window('close');		
		}else{
			if(data="null"){
				parent.$.messager.alert('��ʾ',"δѡ���ͱ���ʧ��");
		    }else{
			    parent.$.messager.alert('��ʾ',"����ʧ��");
			    parent.$("#sysWin").window('close');
			}	
		}
	});	
}