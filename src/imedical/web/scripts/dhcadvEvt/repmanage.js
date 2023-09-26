/// Creator: CongYue
/// CreateDate: 2016-03-29
/// Description: ��̨��������
var url="dhcadv.repaction.csp";
var armaID="",RepID="",RepType="",EpisodeID=""
$(function(){
	
    RepID=getParam("RepID");
    RepType=getParam("RepType");
    armaID=getParam("armaID");
    assessID=getParam("AssessID");
    if(assessID!=""){
         var AssessSave=document.getElementById("AssessSave");
         AssessSave.style.display='none'; //�����������水ť    
	}
 
 	//�����������¼����
	$('#MainCat').combobox({
		//panelHeight:'auto',  //���������߶��Զ�����
		url:url+'?action=SelMainCat',
		onSelect: function(rec){    
           var armaCatDr=rec.value;  
			Combobox(armaCatDr);        
			}
	}); 
	//����취
	$('#DealMethod').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelDealMethod'
	});
	//�Ľ��취
	$('#ImpMethod').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelImpMethod'
	}); 
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
		});
	});
	//��ѡ�����
	InitUIStatus();
	RepManageInfo(RepID,RepType);
})
///��ʼ�����渴ѡ���¼�
function InitUIStatus()
{
	var tmpid="";
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
}
/// �������������Ϣ
function saveRepManage()
{
	///����ǰ,��ҳ���������м��
	if(!saveBeforeCheck()){
		return;
	}
	//1�������¼��ȼ�
	var adrlevel="";
    $("input[type=checkbox][name=adrlevel]").each(function(){
		if($(this).is(':checked')){
			adrlevel=this.value;
		}
	})
	
	if(adrlevel==""){
		$.messager.alert("��ʾ:","�������¼��ȼ�������Ϊ�գ�");
		return false;
	}
	//2�������������¼����
	var MainCat=$('#MainCat').combobox('getValue');
	if(MainCat==""){
		$.messager.alert("��ʾ:","�������¼���𡿲���Ϊ�գ�");
		return false;
	}
	//3���������
	var SubCat=$('#SubCat').combobox('getValue');
	if (SubCat==undefined){
		SubCat=""
	}
	/* if(SubCat==""){
		$.messager.alert("��ʾ:","�������¼�������𡿲���Ϊ�գ�");
		return false;
	} */
	//4������취
	var DealMethod=$('#DealMethod').combobox('getValue');   
	
	//5���Ľ��취
	var ImpMethod=$('#ImpMethod').combobox('getValue');   
	
	//6�������¼�����
	var adrAdvice=$('#adrAdvice').val();

	//7�������Ľ���ʩ
	var adrImprovie=$('#adrImprovie').val();
	if(SubCat!=""){
		MainCat=SubCat
		}
	var params=armaID+"^"+RepType+"^"+RepID+"^"+adrlevel+"^"+MainCat+"^"+DealMethod+"^"+ImpMethod+"^"+adrAdvice+"^"+adrImprovie;
	
	//alert(params);
	
	$.post(url+'?action=SaveRepManage',{"params":params},function(data){
		var armaArr=data.split("^");
		if (armaArr[1]>0) {
			
			$.messager.alert("��ʾ","�����ɹ�!");
            window.parent.closeRepWindow(armaArr[1]);        //wangxuejian 2016-10-09 �ر���������	2017-06-12 �ش�����id
            window.parent.parent.Query();  //2017-03-17 cy ��ѯ��˽�������	
            window.parent.parent.CloseWinUpdate();  //2017-03-28 cy �ر���˽��浯���ı������
	    }else
	    {
		  	 $.messager.alert("��ʾ:","����ʧ��!");
		}
	});
	
}
//���غ�̨������Ϣ
function RepManageInfo(RepID,RepType)
{
	if(RepID==""){return;}
		//��ȡ������Ϣ
 	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetRepManageInfo&adrRepID="+RepID+"&RepType="+RepType,
       success: function(val){
	        var tmp=val.split("!");
	        armaID=tmp[1];   
                
	        if (armaID!=undefined)
			{
			$('#adrleve'+tmp[2]).attr("checked",true);   //�����¼��ȼ�
			$('#MainCat').combobox('setValue',tmp[3]);    //һ�����
	                $('#MainCat').combobox('setText',tmp[10]);    //һ�����
			Combobox(tmp[3]);
			$('#SubCat').combobox('setValue',tmp[4]);     //�������
                        $('#SubCat').combobox('setText',tmp[9]);     //�������			
			
			$('#DealMethod').combobox('setValue',tmp[5]);   //����취
	                $('#DealMethod').combobox('setText',tmp[11]);   //����취

			$('#ImpMethod').combobox('setValue',tmp[6]);   //�Ľ��취
                        $('#ImpMethod').combobox('setText',tmp[12]);   //�Ľ��취
			$('#adrAdvice').val(tmp[7]); //�����¼�����
			$('#adrImprovie').val(tmp[8]); //�����Ľ���ʩ
			$('#AssessSave').hide();//���ر��水ť
			} 
			else {
				armaID=""
			}
	   } ,
       error: function(){
	       alert('���ӳ���');
	       return;
	   }
 
	});
    
}

function Combobox(dr){
            //�������  
            $('#SubCat').combobox({
				//panelHeight:"auto",  //���������߶��Զ�����
				url:url+'?action=SelSubCat&params='+dr
			});    
	
}
	
function saveBeforeCheck(){
	
	//���ܲ����������
	var adrAdvice=$('#adrAdvice').val();
	if(adrAdvice.length>300){
		//var beyond=adrAdvice.length-300;
		$.messager.alert("��ʾ","�����ܲ����������������300����");
		return false;
	}
	
	//�����Ľ���ʩ
	var adrImprovie=$('#adrImprovie').val();
	if(adrImprovie.length>300){
		//var beyond=adrImprovie.length-300;
		$.messager.alert("��ʾ","�������Ľ���ʩ������300����");
		return false;
	}
	return true;	
}
