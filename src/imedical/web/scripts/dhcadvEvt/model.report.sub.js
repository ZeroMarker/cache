//model.js
//�����¼������ӱ���
//zhouxin
//2019-07-15
$(function(){
	initPagination();
	query(1);
});

function query(page){
	runClassMethod("web.DHCADVModel","listData",
		{
			model:$("#modelId").val(),
			pid:pid,
			page:page,
			rows:15,
			st:$('#st').val(),
			ed:$('#ed').val(),
			parStr:$('#parStr').val()
		},function(ret){
			var html="";
			$.each(ret.rows,function(index,itm){
				html+="<tr>";
				var trArr=itm.value.split("^")
				for(var i=0;i<trArr.length;i++){
					html+="<td>"+trArr[i]+"</td>";
				}
				html+="</tr>";
			})
			$("#tableData").html(html);
			var totalPage=Math.ceil(ret.total/15)

			$("#pagination").pagination("setPage", page, totalPage);

		},'json'
	);	
}
function initPagination(){
		$("#pagination").pagination({
			currentPage: 0,
			totalPage: 0,
			isShow: true,
			homePageText: "��ҳ",
			endPageText: "βҳ",
			prevPageText: "��һҳ",
			nextPageText: "��һҳ",
			callback: function(current) {
				query(current)
			}
		});	
}