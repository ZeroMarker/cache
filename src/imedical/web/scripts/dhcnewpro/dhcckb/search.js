/*
*zhouxin
*2019-05-19
*知识库查询界面
*/
$(function(){ 
	initIncCatTree();
	initTab();
	initBTN();
	$('input').keypress(function (e) {
        if (e.which == 13) {
            search();
        }
	});
})

function initIncCatTree(){
	
	$('#incCat').tree({
		onClick: function(node){
			$("#datagrid").datagrid('load',{queryCat:node.id})
		},
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBSearch&MethodName=IncCatTree'
	})	
}

function formatDesc(value,row,index){
	return "<a href='javascript:void(0)' onclick='openWiki("+row.id+")'>"+value+"</a>"	
}
function openWiki(id){
	window.open('dhcckb.wiki.csp?IncId='+id)
}

function initTab(){
	$("#J_SearchTab").find("a").on('click',function(){
		$("#J_SearchTab").find("a").removeClass("cur")
		$(this).addClass("cur")
	})
}

function initBTN(){
	$('.search_btn').on('click',function(){search();})	
}

function search(){
	var queryPar=$("#keyword").val();
	var queryType="name";
	if($("#searcher_2").hasClass('cur')){queryType="indication";};
	if($("#searcher_3").hasClass('cur')){queryType="contraindication";};
	$("#datagrid").datagrid('load',{queryType:queryType,queryPar:queryPar})
}
