//
//����	DHCPENoCheckItemDetail.hisui.js
//����	δ����Ŀ����
//����	2020.02.21
//������  xy
$(function(){
	
	//δ����Ŀ�ؼ����б�
	KeyWordsLoad();
	 
	 initRefuseItem();
	 
	})
	
	
function initRefuseItem()
{
	var RefuseItem=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",EpisodeID);
	$("#RefuseItemInfo").text(RefuseItem);
}
//δ����Ŀ�ؼ����б�̬��ʾ
function KeyWordsLoad()
{	
		$.cm({	
			ClassName: 'web.DHCPE.ResultEdit',
			MethodName: 'GetUnAppedItemsHisui',
			EpisodeID:EpisodeID,
			StationID:"",
			OEFlag:"1",
			LabRecFlag:"1",
		},function(data){
			$('#keywords').keywords({
    				items:data,
   				 	onSelect:function(v){
	   				 
	   				 $.messager.confirm("ȷ��", "ȷʵҪ����'"+v.text+"'��", function(r){
					if (r){
						var OEID=v.id;
						var OEID=OEID.replace('-', '||');
						var ret=tkMakeServerCall("web.DHCPE.ResultEdit","RefuseCheck",OEID);
						 var RefuseItem=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",EpisodeID);
	            		$("#RefuseItemInfo").text(RefuseItem);
	            		KeyWordsLoad();
			
					
						}
					});
	   				 	
   				 	}	 
			});
		});
		
		
}

