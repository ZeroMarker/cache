/**
  *��ҩ����js
  *
**/
var EpisodeID = "7";
/// ҳ���ʼ������
function initPageDefault(){

	InitPatEpisodeID();   
	InitDefaultCon();
	InitPresInfo();	
	
}
///��ʼ��������Ϣ
function InitPatEpisodeID()
{
	//EpisodeID = getParam("EpisodeID");
}
///��ʼ��ҳ��Ĭ������
function InitDefaultCon()
{
	
	runClassMethod("web.DHCCKBMedEducation","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$("#PatName").val(jsonObject.PatName);
		$("#PatSex").val(jsonObject.PatSex);
		$("#PatAge").val(jsonObject.PatAge);
		$("#PatDiag").val(jsonObject.PatDiagDesc);
	},'json',false)
}	
///��ʼ��������Ϣ
function InitPresInfo()
{
	runClassMethod("web.DHCCKBMedEducation","GetPatPresInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var divshow = $("#dataList");
        divshow.text("");				// �������
        		
		var htmlStr = "";
		htmlStr = htmlStr + "<div class='pat-base-area'>"
		htmlStr = htmlStr + 	"<label class='leftbold'>ע�����޴�����</label>"
		htmlStr = htmlStr + 	"<label class='left-20'>Ƶ��:</label><span>"+"ÿ��2��3��"+"</span>"
		htmlStr = htmlStr + 	"<label class='left-20'>���μ���:</label><span>"+"1000��4000��λ"+"</span>"
		htmlStr = htmlStr + 	"<label class='left-20'>��ҩ;��:</label><span>"+"����ע��"+"</span>"
		htmlStr = htmlStr + "</div>"
		htmlStr = htmlStr + "<div class='pat-base-area'>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>ͬ��ҩƷ���ʹ�÷���</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"ͬ��ҩƷ��������������ҩƷӦ���ʹ�ã�������������໥���ã�Ӧ��֪���߻����ջ��߼��ʹ�õķ�����ʹ�ü��ʱ�䡣�翹��ҩ��������̬�Ƽ�����Ҫ���3Сʱ���ϡ�ĳЩҩƷ���������ơ�þ������п���������ϣ��������գ�Ӧ���2-3Сʱ���á�"+"</p></div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>����ҩƷ������Ӧǰ��</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"ĳЩҩƷ���ܻᵼ�����ز�����Ӧ��������֢״�������أ�Ӧ��ȷ��֪���߻��ջ�������֢״������ҩƷ���ز�����Ӧ��ǰ�ף�Ӧ��Ϊ���� ��һ����������֢״��������ͣҩ����ҽ����ڿ򾯸棬��ʾ���е���ز�����Ӧ��Ӧ���ѻ���ע�⡣���ܵ��¹�����Ӧ����������ֱ�䣬�����˶����ܵ��¼����׸�������ѵȡ�������ɵ�Ѫѹ����Ѫ�ǣ������������"+"</p></div>"
		htmlStr = htmlStr + "</div>"
		htmlStr = htmlStr + "<div class='pat-base-area'>"
		htmlStr = htmlStr + 	"<label class='leftbold'>����̹���������ͽ���</label>"
		htmlStr = htmlStr + 	"<label class='left-20'>Ƶ��:</label><span>"+"ÿ��һ��"+"</span>"
		htmlStr = htmlStr + 	"<label class='left-20'>���μ���:</label><span>"+"ÿ��һ����0.2mg��"+"</span>"
		htmlStr = htmlStr + 	"<label class='left-20'>��ҩ;��:</label><span>"+"����ڷ�"+"</span>"
		htmlStr = htmlStr + "</div>"
		htmlStr = htmlStr + "<div class='pat-base-area'>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>��ҩ������巴Ӧ</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"ĳЩҩƷ��ʹ�ú���ܻ����һЩ��������巴Ӧ���������Ż��ߵ����ƣ�Ӧ��֪���߻����ջ�����Щ����������������Һ��ɫ�����ܵ�������"+"</div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>������Ⱥ������ְҵ��</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"ĳЩҩƷ��������Ⱥ������ְҵ��ʹ��ʱ��������Ҫע������Ӧ���������߻����ջ��ߡ��磺�ɵ������벢�����ϳ�ʱ�䣬�����ڼ䲻Ҫ�����������߿���ҵ���ʻ����Ʒ��̥��������Ӱ�죬Ӧ���⻳�С����������ã��и����ã�����ǰ3��������"+"</p></div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>����Ĵ��淽��</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"��Ҫ��������Ĵ��淽��������أ����б����ҩƷ��Ӧ��ȷ��֪���߻����ջ��ߡ���ܹⱣ�棬�䴦���棨2-10�棩"+"</p></div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>©��ҩƷ�Ĵ���취</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"˵��������ȷ˵���©��ҩƷ�Ĵ���취��Ӧ��֪���߻����ջ���"+"</p></div>"
		htmlStr = htmlStr + 	"<label class='leftlabel'>����ҩ���̵�ָ��</label>"
		htmlStr = htmlStr + 	"<div class='text-area'><p>"+"���߲�������ͣҩ��ҩƷ�����ܳ���һ���һ��������Ӧ�𽥼������𽥼�������Ҫʱ����Ӧ�ø�֪���߾���ʲôʱ�䣬Ӧ�ð��Ƴ̹��ɷ�ҩ����ҩ��������3��"+"</p></div>"
		htmlStr = htmlStr + "</div>"
		divshow.append(htmlStr); 	
	},'text',false)
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })