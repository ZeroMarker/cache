/*--------------------------------------------------------------------------*/
/*  McConfig.js
 *  3.2.1 build 2012-08-14
 *  (c) 1997-2012 Medicom
 *--------------------------------------------------------------------------*/
this.WebServiceUrl = "http://10.240.232.161/PassWebService";//���IP��ַ��Ϊ����������ҩ������IP��ַ
this.IsAsyncRecipeCheck = false; //false��ʾͬ����true��ʾ�첽

var MC_WindowWidth = 770; //HISϵͳ�е������ڽ�С-��(px)
var MC_WindowHeight = 530; //HISϵͳ�е������ڽ�С-��(px)

//����ģʽ����
this.IsDebugDrugQueryInfoModel = false;//����ѯ������Ĳ�ѯ����
this.IsDebugPatient = false;//   ����顷����Ĳ��˻�����Ϣ
this.IsDebugRecipes = false;//   ����顷����Ĵ���
this.IsDebugAllergens = false;// ����顷����Ĺ���ʷ
this.IsDebugMedConds = false;//  ����顷����Ĳ���״̬ 
this.IsDebugResultValue =false;//������ֵ��
this.IsDebugShowTime = false;//  ��ģ��ִ��ʱ�䡷


this.DebugShowPanel_DrugQueryInfoModel = "ShowResultMsg";//��ʾ���Դ���Ĳ�ѯ���ݵĿؼ���
this.DebugShowPanel_Patient = "ShowResultMsg";    //��ʾ������Ϣ�Ŀؼ���
this.DebugShowPanel_Recipes = "ShowResultMsg";    //��ʾ���Դ���Ĵ����Ŀؼ���
this.DebugShowPanel_Allergens = "ShowResultMsg";  //��ʾ���Դ���Ĺ���ʷ�Ŀؼ���
this.DebugShowPanel_MedConds = "ShowResultMsg";   //��ʾ���Դ���Ĳ���״̬�Ŀؼ���
this.DebugShowPanel_ResultValue = "ShowResultMsg";//��ʾ����ֵ���ԵĿؼ���