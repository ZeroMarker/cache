$(document).ready(function() {
	$("#search").keydown(
		function(e){
			if(e.keyCode==13) {
				val=$.trim($(this).val())
				
				if(val.length>0){
					$(".boxes > .box > .preview").parent().hide()	
					$(".boxes > .box > .preview:contains('"+val+"')").parent().show()	
				}else{
					$(".preview").parent().show()
				 }
     		}	
		}
	
	) 	
	$("#saveForm").on('click',function(){
		
		formatHtml();
		//alert($("#formatContainer").html())
		var rowArray=new Array()
		//循环row
		$("#formatContainer > .row").each(function(i,obj){
			
			oneArray=new Array()
			//循环一级row下的column 
			$(obj).children().each(function(){	
					
				
				oneSubArray=new Array()
				oneStyle=getStyle($(this).attr("class"));	
				//column 下的元素
				$(this).children().each(function(){
					twoArray=new Array();
					//column下的二级row ，如果是undefined的话子元素是新的row
					if($(this).attr("data-id")==undefined){
						////////////////////////////////////////////////////////////////////////////////////
						
						//二级row 下的 column
						$(this).children().each(function(){
							//二级row 下的 column 下的元素
							subStyle=getStyle($(this).attr("class"));
							twoSubArray=new Array();
							$(this).children().each(function(){
								
								
								if($(this).attr("data-id")==undefined){
									////////////////////////////////////////////////////////////////////////
									//三级row 下的 column
									threeArray=new Array();
									$(this).children().each(function(){
										//三级row 下的 column 下的元素
										threeSubArray=new Array();
										$(this).children().each(function(){
											threeSubArray.push($(this).attr("data-id")+"~"+$(this).attr("data-add"))
										});
										threeArray.push(getStyle($(this).attr("class"))+"+"+threeSubArray.join(","))	
									});
									twoSubArray.push("children2>"+threeArray.join("&"))
								}else{
									twoSubArray.push($(this).attr("data-id")+"~"+$(this).attr("data-add"))
								}
							});
							twoArray.push(subStyle+"*"+twoSubArray.join("%"))	
						});
						oneSubArray.push("children1>"+twoArray.join("$"))
					}else{
						oneSubArray.push($(this).attr("data-id")+"~"+$(this).attr("data-add"))
					}
				})	
				oneArray.push(oneStyle+"#"+oneSubArray.join("@"))
			})
			rowArray.push(oneArray.join("!"))	
		})
		
		//alert(rowArray.join("^"))
		$.post("dhcapp.broker.csp",
			{str:rowArray.join("^"),
			id:$("#formId").val(),
			ClassName:"web.DHCADVAction",
			MethodName:"SaveFormGrid"},function(result){
				//window.location.reload();
				//alert(result)  
				//2017-11-10 congyue 修改alert语句，由直接弹出result改为对result值判断，为0则弹出保存成功，非0则弹出“出错+result”
				if(result==0){ 
					alert("保存成功");	
				}else{
					alert("出错"+result);
				}	
			
		});
	})
	
});


function getRowDataId(value){
	return value==undefined?"row":value;
}

function getStyle(value){
	return value.split(" ")[0];
}

function getTwoLevel(obj,myArray){
	
	
	var myArray=new Array()
	$(obj).children().children().each(function(){	
			style=$(this).parent().attr("class");	
			dataId=$(this).attr("data-id")
			if(dataId==undefined){
				
			}
			alert(style+"^"+$(this).attr("name"))
	})
		
}

function formatHtml(){
	var e = "";
    $("#download-layout").children().html($(".demo").html());
    var t = $("#download-layout").children();
    t.find(".preview, .configuration, .drag, .remove").remove();
    t.find(".lyrow").addClass("removeClean");
    t.find(".box-element").addClass("removeClean");
    t.find(".lyrow .lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
        cleanHtml(this)
    });
    t.find(".lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
        cleanHtml(this)
    });
    t.find(".lyrow .lyrow .lyrow .removeClean").each(function() {
        cleanHtml(this)
    });
    t.find(".lyrow .lyrow .removeClean").each(function() {
        cleanHtml(this)
    });
    t.find(".lyrow .removeClean").each(function() {
        cleanHtml(this)
    });
    t.find(".removeClean").each(function() {
        cleanHtml(this)
    });
    t.find(".removeClean").remove();
    $("#download-layout .column").removeClass("ui-sortable");
    $("#download-layout .row-fluid").removeClass("clearfix").children().removeClass("column");
    if ($("#download-layout .container").length > 0) {
        changeStructure("row-fluid", "row")
    }
    formatSrc = $.htmlClean($("#download-layout").html(), {
        format: true,
        allowedAttributes: [["data-add"],["data-id"],["id"], ["class"], ["data-toggle"], ["data-target"], ["data-parent"], ["role"], ["data-dismiss"], ["aria-labelledby"], ["aria-hidden"], ["data-slide-to"], ["data-slide"]]
    });
    $("#download-layout").children().html(formatSrc)	
}

function copyRow(obj){
	$(obj).parent().parent().append($(obj).parent().clone());
	    $(".demo, .demo .column").sortable({
        connectWith: ".column",
        opacity: .35,
        handle: ".drag"
    });
    $(".sidebar-nav .lyrow").draggable({
        connectToSortable: ".demo",
        helper: "clone",
        handle: ".drag",
        drag: function(e, t) {
            t.helper.width(400)
        },
        stop: function(e, t) {
            $(".demo .column").sortable({
                opacity: .35,
                connectWith: ".column"
            })
        }
    });
    $(".sidebar-nav .box").draggable({
        connectToSortable: ".column",
        helper: "clone",
        handle: ".drag",
        drag: function(e, t) {
            t.helper.width(400)
        },
        stop: function() {
            handleJsIds()
        }
    });
}

function editPro(dicId,itmId,obj){
	
	var myID = "static" + new Date().getTime();
	$(obj).attr("id",myID)
	layer.open({
	  title:'元素属性',	
	  type: 2,
	  area: ['900px', '550px'],
	  fixed: false, //不固定
	  maxmin: true,
	  content: 'dhcadv.layoutformattr.csp?dicId='+dicId+'&itmId='+itmId+'&myID='+myID
	})
}	
