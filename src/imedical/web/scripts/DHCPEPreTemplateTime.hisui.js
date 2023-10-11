//
//����	DHCPEPreTemplateTime.hisui.js
//����  ʱ����Ϣ
//����	2019.01.29
//������  xy


$(function(){
	
	InitPreTemplateTimeDataGrid();
	
	//����  
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
    //ɾ��
    $("#BDelete").click(function() {	
		 BDelete_click();		
   
        }); 
 
})

function BUpdate_click()
{
	
	var ID=getValueById("ID");
	var StartTime=getValueById("StartTime");
	if (StartTime==""){
		$.messager.alert("��ʾ","��ʼʱ�䲻��Ϊ��","info");
		return false;
	}
	var EndTime=getValueById("EndTime");
	if (EndTime==""){
		$.messager.alert("��ʾ","����ʱ�䲻��Ϊ��","info");
		return false;
	}
	var Num=getValueById("Num");
	if (Num=="" || Num=="-"){
		MaleNum = 0;
		FemaleNum = 0;
	} else {
		MaleNum = Num.split("-")[0];
		FemaleNum = Num.split("-")[1];	
	}
	if(Num.indexOf("-")<0){
		$.messager.alert("��ʾ","����ά����ʽ����ȷ,��ʽӦΪ���������У�-������Ů��,���磺10-20","info");
		return false;
		}
		 
   
 	if(Num.indexOf("-")>=0){

	MaleNum = Num.split("-")[0];
	FemaleNum = Num.split("-")[1];
	if((MaleNum=="")||(MaleNum==undefined)||(FemaleNum=="")||(FemaleNum==undefined))
	 {
		  $.messager.alert("��ʾ","����ά����ʽ����ȷ,��ʽӦΪ���������У�-������Ů��,���磺10-20");
         return false;
	 }
	 
	if (!isNumber(MaleNum))
	{ 
		 $.messager.alert("��ʾ","����ά����ʽ����ȷ,��ʽӦΪ���������У�-������Ů��,���磺10-20","info");
        return false;
	}

	if(!isNumber(FemaleNum)) {
         $.messager.alert("��ʾ","����ά����ʽ����ȷ,��ʽӦΪ���������У�-������Ů��,���磺10-20","info");
        return false;
      }
    
   }
    
	var currentMale = 0;  ///����ԤԼ����
	var currentFemale = 0;
	
	var ret=tkMakeServerCall("web.DHCPE.PreTemplate","SearchPeopleCount",ParRef,Type);
	currentMale = (ret.split("-"))[0];
	currentFemale = (ret.split("-"))[1];
	if(currentMale == null || currentMale == "" || currentMale == undefined){
		currentMale = 0;	
	}
	if(currentFemale == null || currentFemale == "" || currentFemale == undefined){
		currentFemale = 0;	
	}
	currentMale = parseInt(currentMale);
	currentFemale = parseInt(currentFemale);

	var totalMaleNum = 0; ///��ʱ��������
	var totalFemaleNum = 0;
	
    var objtbl = $("#PreTemplateTimeQueryTab").datagrid('getRows');
	var rows=objtbl.length;
	

	for (var i=0;i<rows;i++){
			
		var TID=objtbl[i].TID;
		var tobjMale=objtbl[i].TNumMale;
		var tobjFemale=objtbl[i].TNumFemale;
		
		tobjMale = parseInt(tobjMale);
		tobjFemale = parseInt(tobjFemale);
		if(TID != ID){
			totalMaleNum = totalMaleNum + tobjMale;
			totalFemaleNum = totalFemaleNum + tobjFemale;
		}
	}

	MaleNum = parseInt(MaleNum);
	FemaleNum = parseInt(FemaleNum);
	
	totalMaleNum = totalMaleNum + MaleNum;
	totalFemaleNum = totalFemaleNum + FemaleNum;
	
	if(totalMaleNum > currentMale){
		var balance = totalMaleNum - currentMale;
		$.messager.alert("��ʾ","���Է�ʱ������������ԤԼ�޶����ʧ�ܣ����Ϊ��"+balance+" ��","info");
		return false;		
	
	}
	
	if(totalFemaleNum > currentFemale){
		var balance = totalFemaleNum - currentFemale;
		$.messager.alert("��ʾ","Ů�Է�ʱ������������ԤԼ�޶����ʧ�ܣ����Ϊ��"+balance+" ��","info");
		return false;	
		
	
	}

	var Info=StartTime+"^"+EndTime+"^"+MaleNum+"^"+FemaleNum;
	var ret=tkMakeServerCall("web.DHCPE.PreTemplate","UpdateTimeInfo",Type,ParRef,ID,Info);
	
	if (ret=="1"){
		//window.location.reload();
		 $("#PreTemplateTimeQueryTab").datagrid('load',{
			    ClassName:"web.DHCPE.PreTemplate",
				QueryName:"SerchTimeInfo", 
				Type:Type,
				ParRef:ParRef,
		}); 
		
		window.parent.$("#PreGADMHomeGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreHome",
			QueryName:"SerchHomeInfo",
			PGADMDr:PreGADM,
			Type:"G"
		}); 
		
		
	}else{
		$.messager.alert("��ʾ",ret,"info");
	}
}
function BClear()
{
	$("#Num,#ID,#EndTime,#StartTime").val("") 
	
}

function BDelete_click()
{
	
	var ID=getValueById("ID");
	if(ID==""){
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return false;	
	}
	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.PreTemplate", MethodName:"DeleteTimeInfo",Type:Type,ID:ID},function(ReturnValue){
					
				if (ReturnValue!="0") {
					$.messager.alert("��ʾ","ɾ��ʧ��:"+ReturnValue,"error");
					
				}else{
					$.messager.alert("��ʾ","ɾ���ɹ�","success");
					
					 BClear();
					 
					 $("#PreTemplateTimeQueryTab").datagrid('load',{
			    		ClassName:"web.DHCPE.PreTemplate",
						QueryName:"SerchTimeInfo", 
						Type:Type,
						ParRef:ParRef,
			    		}); 
			    		
					window.parent.$("#PreGADMHomeGrid").datagrid('load',{
						ClassName:"web.DHCPE.PreHome",
						QueryName:"SerchHomeInfo",
						PGADMDr:PreGADM,
						Type:"G"
					}); 
				}
				});
		}
	});

}

function ShowPreManagerInfo(e)
{
	var DateStr=e.id;
	//var lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreManager'+"&DateStr="+DateStr;
	var lnk="dhcpepremanager.hisui.csp?DateStr="+DateStr;
	websys_lu(lnk,false,'width=950,height=545,hisui=true,title=ԤԼ������Ϣ')
}


//�ж�������ַ����Ƿ�Ϊ�Ǹ�����
function isNumber(elem){
 var pattern= /^\d+$/;
 if(pattern.test(elem)){
  return true;
 }else{
  return false;
 }
}


function InitPreTemplateTimeDataGrid(){

	$HUI.datagrid("#PreTemplateTimeQueryTab",{
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PreTemplate",
			QueryName:"SerchTimeInfo", 
			Type:Type,
			ParRef:ParRef,
		},columns:[[
			{field:'TParRef',hidden:true,title:'����id'},
			{field:'TID',hidden:true,title:'����id'},
			{field:'TStartTime',width:'150',title:'��ʼʱ��'},
			{field:'TEndTime',width:'150',title:'����ʱ��'},
			{field:'TNumMale',width:'120',title:'����(��)'},
			{field:'TNumFemale',width:'120',title:'����(Ů)'},		
		
				
		]],
		onSelect: function (rowIndex, rowData) {
			var ID=rowData.TID;
			var StartTime=rowData.TStartTime;
			var EndTime=rowData.TEndTime;
			var MaleNum=rowData.TNumMale;
			var FemaleNum=rowData.TNumFemale;
			
			setValueById("ID",ID);
	       setValueById("StartTime",StartTime);
		   setValueById("EndTime",EndTime);
		    var num=MaleNum+"-"+FemaleNum;
		    setValueById("Num",num);	
			
		}

	
	})
}

