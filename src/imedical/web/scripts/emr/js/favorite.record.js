﻿$(function(){
	getRecords();
});

///我的收藏
function getRecords()
{
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.favorites.cls", 
        data: "Action=GetFavRecords&FavInfoID="+favInfoId, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	setRecords(eval(data));
        } 
    });	
}

///加载病例列表
function setRecords(data)
{
	$(".recordList").empty();
	for (var i=0;i<data.length;i++)
	{
		var li = $('<li></li>');
		var link = $('<a></a>');
		$(link).attr("id",data[i].id);       
		$(link).attr("href","javascript:void(0);");
		$(link).attr("infoId",data[i].infoId);
		var recordInfo = "<span>";
		    recordInfo = recordInfo + "<div class='record'>"
		    recordInfo = recordInfo + "<div>"+data[i].text+"</div>"
		    recordInfo = recordInfo + "<div>"+data[i].dataTime+"</div>"
		    recordInfo = recordInfo + "<div>"+data[i].creator+"</div>"
		    recordInfo = recordInfo + "</div>"
		    recordInfo = recordInfo + "</span>"
		$(link).append(recordInfo);
		var operation = "span";
		    operation = operation + "<div><input type='button' value='查看病历' onclick='openRecord("+data[i].id+")'/></div>";
		    operation = operation + "<div><input type='button' value='删除病历' onclick='deleteInfomation("+data[i].id+")'/></div>";
		    operation = operation + "<div><input type='button' value='增加备注'/onclick='modifymemo("+data[i].id+")' ></div>";
  
		$(".recordList").append(li);  
		      
	}
	
}