ImportJqueryUI();

var createMedication = function(Params){
	this.Params = Params;	
}
	
createMedication.prototype.init=function(){	

	initTable();
	
	initDiv();
	
	dragDiv();
	
	initMethod();
	
	
}

addTr = "";
addTrs="";
//����CSS liangqiang 2014-05-20
function ImportCssByLink(url){  
  var link = document.createElement("link");
	  link.type = "text/css";
	  link.rel = "stylesheet";
	  link.href = url;
	  document.getElementsByTagName("head")[0].appendChild(link);
     
}

//����JqueryUI��ػ���
function ImportJqueryUI()
{
	var url="../scripts/dhcnewpro/dhcem/css/medication.css"
	ImportCssByLink(url)
}
//��̬����div
function initTable(){
	
	var bigDiv = " <div id='medication'>";
	bigDiv += "<div id='medititle'>";
	bigDiv += "<div id='meditle'>֪ʶ������Ϣ</div>";
	bigDiv += "<div id='mediclose'><img src='../scripts/dhcnewpro/images/close.png'></img></div></div>";
	bigDiv +="<div id='medicont'></div></div>"
	$(document.body).append(bigDiv);
	$("#medication").show();
	Params="����������ע��Һ,10403321||1827:û��ά��$C(1)ע����Ͷ��ʲôʲô��,10403321||1825:��ҩƵ��@�޴�Ƶ��!������ҩ@ʹ�ø�ҩ5%������(�Ĵ�)250ml��Һ�ͱ���ʹ�ô���5ml���ע����ˮ!������ҩ����@������������ҩ���ܳ���2��AAAAAA!�÷�����@����2gccc$C(1)����������ע��Һ,10403321||1827:û��ά��"
	Params=Params+"$C(1)ע����Ͷ��ʲôʲô��,10403321||1825:��ҩƵ��@�޴�Ƶ��!������ҩ@ʹ�ø�ҩ5%������(�Ĵ�)250ml��Һ�ͱ���ʹ�ô���5ml���ע����ˮ!������ҩ����@������������ҩ���ܳ���2��AAAAAA!�÷�����@����2gccc$C(1)����������ע��Һ,10403321||1827:û��ά��"
	//Params="ע����Ͷ��ʲôʲô��,10403321||1825:��ҩƵ��@�޴�Ƶ��$C(1)����������ע��Һ,10403321||1827:û��ά��"
	//Params="ע����Ͷ��ʲôʲô��,10403321||1825:��ҩƵ��@�޴�Ƶ��"
	alert(Params)
	var BlockArr= Params.split("$C(1)");
	
	for(var x=0;x<BlockArr.length;x=x+1){// edit by yuliping 
	
		init(x);	

	}

}

//���ڵ��϶�
function initDiv(){	
    var bool = false;
    var offsetX = 0;
    var offsetY = 0;
    $("#medititle").mousedown(function () {
        bool = true;
        offsetX = event.offsetX;
        offsetY = event.offsetY;

        $("#medititle").css('cursor', 'move');
    })
     .mouseup(function () {
           bool = false;
     })
    $(document).mousemove(function (e) {
        if (!bool)
            return;
        var x = event.clientX - offsetX;
        var y = event.clientY - offsetY;
        $("#medication").css("left", x);
        $("#medication").css("top", y);
    }) 
}

function dragDiv(){
	
	//���ڵ��϶�
    var bool = false;
    var offsetX = 0;
    var offsetY = 0;
    $("#detailtitle").mousedown(function () {
        bool = true;
        offsetX = event.offsetX;
        offsetY = event.offsetY;

        $("#detailtitle").css('cursor', 'move');
    })
     .mouseup(function () {
           bool = false;
     })
    $(document).mousemove(function (e) {
        if (!bool)
            return;
        var x = event.clientX - offsetX;
        var y = event.clientY - offsetY;
        $("#detailcont").css("left", x);
        $("#detailcont").css("top", y);
    }) 		
}

//�󶨷���
function initMethod(){
	
	$("#mediclose").on('click',function () {
        $("#medication").hide();
        addTr = "";//���ڹر�֮�����
        addTrs="";
    }); 

    $("#detailclose").on('click',function () {
        $("#detail").css("display","none");
    });
	}


//��̬������һ��div
function datailTable(){
	
	datailTr = "";
	datailTr +="<table class='datailTb' cellspacing='0' cellpadding='0'>";
	datailTr +="<tr><td class='table_title'>��"+'��1��'+"��</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>������������</td></tr>";
	datailTr +="<tr><td class='table_title'>��"+'��1��'+"��</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>������������</td></tr>";
	datailTr +="<tr><td class='table_title'>��"+'��1��'+"��</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>������������</td></tr>";
	datailTr +="<tr><td class='table_title'>��"+'��1��'+"��</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>������������</td></tr>";
	datailTr +="<tr><td class='table_title'>��"+'��1��'+"��</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>������������</td></tr>";
	datailTr +="<tr><td class='table_title'>��"+'��1��'+"��</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>������������</td></tr>";
	datailTr +="<tr><td class='table_title'>��"+'��1��'+"��</td></tr>";
	datailTr +="<tr><td class='tb_td_bk'>������������</td></tr>";
	datailTr +="</table>"
	$("#detailcont").html(datailTr)	
	
}

//�������Ŀ¼��ʾ	
function otherList(){
	e = event;
	//var className=$(e.target).attr("class");   ��ie8��ʶ��
	var className=$(e.srcElement).attr("class");
	var tdNum = $(e.srcElement).attr("tdNum");
	$(e.srcElement).parents("table").find("td:first").attr("rowspan",tdNum);
	$("."+className).show();
	//$(e.target).parents("tr").hide();  ie8��֧��
	$(e.srcElement).parents("tr").hide();
}

//�������Ŀ¼��ʾ	
function otherLists(){
	e = event;
	//var className=$(e.target).attr("class");   ��ie8��ʶ��
	//var tdNum = $(e.srcElement).attr("tdNum");
	//$(e.srcElement).parents("table").find("td:first").attr("rowspan",tdNum);
	//$(e.target).parents("tr").hide();  ie8��֧��
	$(e.srcElement).parents("tr").hide();
	$("#medicont").append(addTr);
	
}		


//���������Ŀ��ʾ
function otherProject(){
	$(".medicontTb").show();
	$("#otherProject").hide();	
}

function detail(){
	$("#detail").show();	
}

//��̬����table yuliping  ����
/*function initTables(x){
	
	var BlockArr= Params.split("$C(1)");
	var TrArr = BlockArr[x].split("#")[1].split("!");//��һ��
	var TrArrLength = TrArr.length+1;
	
	
	var tit="<div class='table_title' style='border-bottom: 1px solid #ccc;padding-top: 3px;'>��["+BlockArr.length+"]��</div>";
	
	
	addTr +="<div class='table_title' style='margin:5px 0 0 7px;width:566px;border-bottom: 1px solid #ccc;	font-weight:bold;padding: 3px 0 0 5px;background-color:#DDDDDD;'>��"+(x+1)+"��</div>";
	
	addTr +="<table  cellpadding='0' cellspacing='0' class='medicontTb'><tr><td style='background-color:#F6F6F6' >������ҩ����</td><td colspan='2'>"+BlockArr[x].split("#")[0]+"</td></tr>";
	for(var y=0;y<TrArr.length;y++){
		addTr +="<tr><td style='background-color:#F6F6F6;width:100px;' >��"+TrArr[y].split("@")[0]+"��</td><td style='border-right:solid #E3E3E3 1px' colspan='2' >"+TrArr[y].split("@")[1]+"</td></tr>";
		}
		
	
	if(x==0){
		addTrs=addTr;
		addTrs=tit+addTrs
		addTrs +="<tr><td><a href='#' onclick='otherLists()' tdNum='"+TrArrLength+"' class='trId"+x+"' style='font-size: 10px;'>������Ϣ[+]</a></td><td></td></tr>";			
		addTrs +="</table>";
		}else{
		addTr +="</table>";
	}
	$("#medicont").html(addTrs);
	
	}*/
//��̬����table yuliping 
function init(x){
	
	var BlockArr= Params.split("$C(1)");
	var TrArrs = BlockArr[x].split(":")[1]
	
	var TrArr = BlockArr[x].split(":")[1].split("!");
	var TrArrLength = TrArr.length+1;
	
	if(x==0){ 
		
		addTrs +="<div class='table_title' style='border-bottom: 1px solid #ccc;padding-top: 3px;'>��["+BlockArr.length+"]��</div>";

		addTrs +="<div class='table_title' style='margin:5px 0 0 7px;width:566px;border-bottom: 1px solid #ccc;	font-weight:bold;padding: 3px 0 0 5px;background-color:#DDDDDD;'>��"+(x+1)+"��</div>";
	
		addTrs +="<table  cellpadding='0' cellspacing='0' class='medicontTb'><tr><td style='background-color:#F6F6F6;width:120px' >������ҩ����</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+BlockArr[x].split(",")[0]+"</td></tr>";
		if(TrArrs=="û��ά��"){
			
			addTrs +="<tr><td colspan='3'  style='border-right:solid #E3E3E3 1px'>û��ά������</td></tr>";
		}else{                                   //��һ��
		
			for(var y=0;y<TrArr.length;y++){
				addTrs +="<tr><td style='background-color:#F6F6F6;width:120px;' >��"+TrArr[y].split("@")[0]+"��</td><td style='border-right:solid #E3E3E3 1px' colspan='2' >"+TrArr[y].split("@")[1]+"</td></tr>";
				}

		}
		if((x==0)&&(BlockArr.length>1)){
			
			addTrs +="<tr><td><a href='#' onclick='otherLists()' tdNum='"+TrArrLength+"' class='trId"+x+"' style='font-size: 10px;'>������Ϣ[+]</a></td><td></td></tr>";			
		}
		addTrs +="</table>";
		
		$("#medicont").html(addTrs);
	}else{						//ʣ�༸��	
	
	addTr +="<div class='table_title' style='margin:5px 0 0 7px;width:566px;border-bottom: 1px solid #ccc;	font-weight:bold;padding: 3px 0 0 5px;background-color:#DDDDDD;'>��"+(x+1)+"��</div>";
	
	addTr +="<table  cellpadding='0' cellspacing='0' class='medicontTb'><tr><td style='background-color:#F6F6F6;width:120px;' >������ҩ����</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+BlockArr[x].split(",")[0]+"</td></tr>";	  					 
		if(TrArrs=="û��ά��"){
		
			addTr +="<tr><td colspan='3'  style='border-right:solid #E3E3E3 1px'>û��ά������</td></tr>";
		}else{
	
			for(var y=0;y<TrArr.length;y++){
			addTr +="<tr><td style='background-color:#F6F6F6;width:120px;' >��"+TrArr[y].split("@")[0]+"��</td><td style='border-right:solid #E3E3E3 1px' colspan='2' >"+TrArr[y].split("@")[1]+"</td></tr>";
			}
		}
	addTr +="</table>";
			
	}
	

}