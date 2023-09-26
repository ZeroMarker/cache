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
		//ѭ��row
		$("#formatContainer > .row").each(function(i,obj){
			
			oneArray=new Array()
			//ѭ��һ��row�µ�column 
			$(obj).children().each(function(){	
					
				
				oneSubArray=new Array()
				oneStyle=getStyle($(this).attr("class"));	
				//column �µ�Ԫ��
				$(this).children().each(function(){
					twoArray=new Array();
					//column�µĶ���row �������undefined�Ļ���Ԫ�����µ�row
					if($(this).attr("data-id")==undefined){
						////////////////////////////////////////////////////////////////////////////////////
						
						//����row �µ� column
						$(this).children().each(function(){
							//����row �µ� column �µ�Ԫ��
							subStyle=getStyle($(this).attr("class"));
							twoSubArray=new Array();
							$(this).children().each(function(){
								
								
								if($(this).attr("data-id")==undefined){
									////////////////////////////////////////////////////////////////////////
									//����row �µ� column
									threeArray=new Array();
									$(this).children().each(function(){
										//����row �µ� column �µ�Ԫ��
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
				//2017-11-10 congyue �޸�alert��䣬��ֱ�ӵ���result��Ϊ��resultֵ�жϣ�Ϊ0�򵯳�����ɹ�����0�򵯳�������+result��
				if(result==0){ 
					alert("����ɹ�");	
				}else{
					alert("����"+result);
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
	  title:'Ԫ������',	
	  type: 2,
	  area: ['900px', '550px'],
	  fixed: false, //���̶�
	  maxmin: true,
	  content: 'dhcadv.layoutformattr.csp?dicId='+dicId+'&itmId='+itmId+'&myID='+myID
	})
}	
