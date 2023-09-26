$(function(){
	$('#Parent').text(parentname);
	$('#Parent').attr('readonly','readonly');
	$('#Parent').attr('disabled','disabled');
	$('#submit').bind('click',function(){
		if($('#Code').val()==""||$('#Desc').val()=="") return;
		$.ajax({
			type: "GET",
			dataType: "text",
			url: "../EMRservice.Ajax.common.cls",
			data: {
				"OutputType":"String",
				"Class":"EMRservice.BL.BLiBookCategory",
				"Method":"AddCategory",
				"p1":$('#Code').val(),
				"p2":$('#Desc').val(),
				"p3":parentid,
				"p4":userID+'^'+userLocID+'^'+ssgroupID+'^'
			},
			//成功返回目录ID，否则返回0
			success: function(d){
				if(d.substr(0,3)=="100"){
					alert('新增成功');
					//在父页面的对应位置加入新目录，如果有‘其他’则加在其他前，否则默认加在最末					
					d = d.substr(4);
					var subitem = makesubitem(d);
					var Category = $('#CG'+parentid, window.parent.document)[0].lastChild;
					if(Category != null){
						if($(Category).find('dl').attr('id').substr(0,3) == 'CG0'){
							$(Category).before(subitem);
							return;
						}
					}
					$('#CG'+parentid, window.parent.document).append(subitem);
				}else{
					alert('操作失败');
				}
			},
			error: function(d){
				alert("error");
			}
		});
	});
});

function makesubitem(CategoryID){
	var subitem = $('<div class="subitem" style="width:auto"></div>');
	var content = $('<dl></dl>');
	$(content).append('<dt><a href="#">'+$('#Desc').val()+'</a></dt>');
	$(content).attr('id',CategoryID);
	$(content).append($('<dd></dd>'));
	$(subitem).append(content);
	return subitem;
}