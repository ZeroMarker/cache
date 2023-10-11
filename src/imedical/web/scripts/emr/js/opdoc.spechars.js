var returnValue= ""
$(function(){
    selectValue = "";
    getSpechars();
});


//获取特殊字符
function getSpechars()
{
    jQuery.ajax({
        type: "Post",
        dataType: "json",
        url: "../EMRservice.Ajax.spechars.cls",
        async: true,
        success: function(d) {
            setSpechars(eval(d));
        },
        error : function(d) { alert(" error");}
    });
}

//初始化特殊字符
function setSpechars(data)
{
    for (var i=0;i<data.length;i++)
    {
        var content = $('<div class="content"></div>');
        for (var j=0;j<data[i].Values.length;j++)
        {
            $(content).append('<div id="'+data[i].Values[j].Code+'" onclick="select(this)">'+data[i].Values[j].Desc+'</div>');
        }
        if (i == data.length-1)
        {
            addTab(data[i].Code,data[i].Desc,content,false,true);
        }
        else
        {
            addTab(data[i].Code,data[i].Desc,content,false,false);
        }
    }
}

//增加tab标签
function addTab(id,title,content,closable,selected)
{
    $('#spechars').tabs('add',{ 
        id:id, 
        title:title,  
        content:content,  
        closable:closable,
        selected:selected
    });  
}

//选择特殊字符
//$(".content div").live("click",function(){
function select(selectSpechar){
    var values = $("#selectValue").val();
    values = values + selectSpechar.innerText;
    var thisValue = selectSpechar.id;
    if (thisValue.indexOf("<SUP>") > 0)
    {
        if (thisValue.substring(0,thisValue.indexOf("<SUP>"))!="" )
        {
            selectValue = selectValue + "^" + thisValue.substring(0,thisValue.indexOf("<SUP>")) + "#DEFAULT";
        }
        if (thisValue.substring(thisValue.indexOf("<SUP>")+5,thisValue.indexOf("</SUP>"))!="" )
        {
            selectValue = selectValue + "^" + thisValue.substring(thisValue.indexOf("<SUP>")+5,thisValue.indexOf("</SUP>")) + "#SUPER";
        }
        if (thisValue.substring(thisValue.indexOf("</SUP>")+6)!="" )
        {
            selectValue = selectValue + "^" + thisValue.substring(thisValue.indexOf("</SUP>")+6) + "#DEFAULT";
        }
    }
    else if (thisValue.indexOf("<SUB>") > 0)
    {
        if (thisValue.substring(0,thisValue.indexOf("<SUB>"))!="" )
        {
            selectValue = selectValue + "^" + thisValue.substring(0,thisValue.indexOf("<SUB>")) + "#DEFAULT";
        }
        if (thisValue.substring(thisValue.indexOf("<SUB>")+5,thisValue.indexOf("</SUB>"))!="" )
        {
            selectValue = selectValue + "^" + thisValue.substring(thisValue.indexOf("<SUB>")+5,thisValue.indexOf("</SUB>")) + "#SUB";
        }
        if (thisValue.substring(thisValue.indexOf("</SUB>")+6)!="" )
        {
            selectValue = selectValue + "^" + thisValue.substring(thisValue.indexOf("</SUB>")+6) + "#DEFAULT";
        }
    } 	
    else
    {
        selectValue = selectValue + "^" + thisValue + "#DEFAULT";
    }
    $("#selectValue").val(values);
}

$("#sure").click(function(){
    jQuery.ajax({
            type : "GET", 
            dataType : "text",
            url : "../EMRservice.Ajax.common.cls",
            async : false,
            data : {
                    "OutputType":"String",
                    "Class":"EMRservice.BL.BLSpechars",
                    "Method":"GetSpecharsStyleTextJson",
                    "p1":selectValue
                },
            success : function(d) {
               if ( d != "") 
               {
                   window.returnValue = d  ;
               }
            },
            error : function(d) { alert("delete getSpecharsStyleTextJson error");}
        });
    closeWindow();
});

$("#clear").click(function(){
    $("#selectValue").val("");
    selectValue = "";
});

$("#close").click(function(){
   
    closeWindow();
});
//关闭窗口
function closeWindow()
{
	var id = 'spechars';
	parent.closeDialog(id);
}
