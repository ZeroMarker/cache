//
//名称	DHCPENoCheckItemDetail.hisui.js
//功能	未检项目详情
//创建	2020.02.21
//创建人  xy
$(function(){
	
	//未检项目关键词列表
	KeyWordsLoad();
	 
	 initRefuseItem();
	 
	})
	
	
function initRefuseItem()
{
	var RefuseItem=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",EpisodeID);
	$("#RefuseItemInfo").text(RefuseItem);
}
//未检项目关键字列表动态显示
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
	   				 
	   				 $.messager.confirm("确认", "确实要放弃'"+v.text+"'吗", function(r){
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

