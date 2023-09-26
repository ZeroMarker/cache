$(function(){
	initSlt = initSlt.replace(/,/g,'^');
	$('#KBNode').text(NodeName);
	$('#KBNode').attr('readonly','readonly');
	$('#KBNode').attr('disabled','disabled');
	$('#ItemList').tree({
		url: '../EMRservice.Ajax.Repository.cls?Action=GetiBookList&userLocID=' + userLocID,
		method: 'get',
        animate: true,
        checkbox: true,
		checked: false,
		onlyLeafCheck:true,
		onLoadSuccess:function(node,data){
			for(var i=0;i<data.length;i++){
				var id=data[i].id.substr(2);
				var re =new RegExp('^'+id+'\\^|\\^'+id+'$|^'+id+'$|\\^'+id+'\\^'); // re为/^id\^|\^id$|^id$|\^id\^/
				if(initSlt.match(re)){
					var curnode = $(this).tree('find',data[i].id);
					$(this).tree('check', curnode.target);
				}else{
					if(unSltItem!='') unSltItem=unSltItem+'^';
					unSltItem = unSltItem+id;
				}
			}
			SltItem = initSlt;
		},
		onCheck:function(node,checked){
			//如果在Slt中，删除Slt，添加unSlt；如果不在反之
			var id = node.id.substr(2);
			var re1 =new RegExp('^'+id+'\\^|\\^'+id+'$|^'+id+'$'); // re为/^id\^|\^id$|^id$/
			if(r = SltItem.match(re1)){
				SltItem = SltItem.replace(r[0],'');
				if (unSltItem!="") unSltItem = unSltItem+"^";
				unSltItem = unSltItem+id;
				return;
			}
			var re2 =new RegExp('\\^'+id+'\\^'); // re为/\^id\^/		
			if(r = SltItem.match(re2)){
				SltItem = SltItem.replace(r[0],'^');
				if (unSltItem!="") unSltItem = unSltItem+"^";
				unSltItem = unSltItem+id;
				return;
			}
			if(r = unSltItem.match(re1)){
				unSltItem = unSltItem.replace(r[0],'');
				if (SltItem!="") SltItem = SltItem+"^";
				SltItem = SltItem+id;
				return;
			}
			if(r = unSltItem.match(re2)){
				unSltItem = unSltItem.replace(r[0],'^');
				if (SltItem!="") SltItem = SltItem+"^";
				SltItem = SltItem+id;
				return;
			};
		}
    });
});

document.getElementById('SetKBNodeBind').onclick = function(){
	$.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLiBookLink",
			"Method":"SetiBkBNodeLink",
			"p1":NodeID,
			"p2":SltItem,
			"p3":unSltItem
		},
		success: function(d){
			if(d==1){
				alert('配置成功');
				window.returnValue = SltItem;
				window.close();
			}else{
				alert('操作失败');
			}
		},
		error: function(d){
			alert("error");
		}
	});
};