//ȫ��
var FSReviewView = FSReviewView || {
    SelectEpisode: "",
    Back2Doc: "0",
    Back2Nur: "0",

    //���з�������
    QCBack: null
};

//���ú;�̬
FSReviewView.Config = FSReviewView.Config || {
    ERROR_INFO: "����",
    ERROR_INFO_EPISODEINFO: "��ȡ������Ϣʧ�ܣ�",
    ERROR_INFO_REVIEW: "����ʧ�ܣ������³��Ի���ϵ����Ա",
    ERROR_INFO_QCBACK: "�˻�ʧ�ܣ������³��Ի���ϵ����Ա",
    LOADING_INFO: "����װ����......"
};

(function (win) {
    $(function () {

        //��ʼ�����з���
        FSReviewView.QCBack = qcback;

        //���û�����Ϣ
        setPatInfo();

        //�ر�ʱ���ø�ҳ��ˢ���б�
        window.onbeforeunload = onbeforeunload_handler;
        function onbeforeunload_handler() {
            searchEpisode();
            return;
        }

        //------------------------------------------------------------------------------------------------------------------

        //�ر�
        $('#windowCloseBtn').on('click', function () {
            FSReviewCommon.CloseWebPage();
        });

        //����ͨ��
        $('#passBtn').on('click', function () {
            getSelectEpisode();
            var obj = $.ajax({
                url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=reviewpass&EpisodeID=" + FSReviewView.SelectEpisode + "&UserID=" + userID,
                type: 'post',
                async: false
            });

            FSReviewView.SelectEpisode = "";
            var ret = obj.responseText;
            if (ret !== "1") {
                $.messager.alert(FSReviewView.Config.ERROR_INFO, FSReviewView.Config.ERROR_INFO_REVIEW, 'error');
                return;
            }
            else {
                searchEpisode();
                FSReviewCommon.CloseWebPage();
            }
        });

        //�˻�ҽ��
        $('#back2DocBtn').on('click', function () {
            FSReviewView.Back2Doc = "1";
            FSReviewView.Back2Nur = "0";
            getSelectEpisode();
            FSReviewCommon.OpenBackWin(FSReviewView.QCBack);
        });

        //�˻ػ�ʿ
        $('#back2NurBtn').on('click', function () {
            FSReviewView.Back2Doc = "0";
            FSReviewView.Back2Nur = "1";
            getSelectEpisode();
            FSReviewCommon.OpenBackWin(FSReviewView.QCBack);
        });

        //ȫ���˻�
        $('#back2AllBtn').on('click', function () {
            FSReviewView.Back2Doc = "1";
            FSReviewView.Back2Nur = "1";
            getSelectEpisode();
            FSReviewCommon.OpenBackWin(FSReviewView.QCBack);
        });
		
		//���Ӳ�������
        $('#viewEPRBtn').on('click', function () {
			openEPR2Win();
        });

        //------------------------------------------------------------------------------------------------------------------

		function openEPR2Win() {
            var iWidth = screen.availWidth - 10;                         //�������ڵĿ��;
            var iHeight = screen.availHeight - 30;                       //�������ڵĸ߶�;
            var iTop = 0;       //��ô��ڵĴ�ֱλ��;
            var iLeft = 0;
            var url = 'epr.newfw.main.csp?EpisodeID=' + episodeID;
            window.showModalDialog(url, "", 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken');
        }
		
        function setPatInfo() {
            var ret = "";
            var obj = $.ajax({
                url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=getepisodeinfo&EpisodeID=" + episodeID,
                type: 'post',
                async: false
            });
            var ret = obj.responseText;
            if ((ret != "") && (ret != null) && (ret != "-1")) {
                var arr = new Array();
                arr = ret.split("^");
                //MedRecordNo_"^"_RegNo_"^"_patientID_"^"_AEpisodeID_"^"_Name_"^"_Gender_"^"_admDate_"^"_disDate_"^"_admLoc_"^"_disLoc
                var medRecordNo = arr[0];
                var regNo = arr[1];
                var name = arr[4];
                var gender = arr[5];
                var admDate = arr[6];
                var disDate = arr[7];
                var admLoc = arr[8];
                var disLoc = arr[9];

                var splitor = '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp';
                var htmlStr = '&nbsp<div style="margin:3px">';
                htmlStr += '<span style="font-family:΢���ź�;font-size:14px;">�����ţ�</span><span style="font-family:΢���ź�;color:#008b8b;font-size:14px;">' + medRecordNo + '</span>' + splitor;
                htmlStr += '<span style="font-family:΢���ź�;font-size:14px;">�ǼǺţ�</span><span style="font-family:΢���ź�;color:#008b8b;font-size:14px;">' + regNo + '</span>' + splitor;
                htmlStr += '<span style="font-family:΢���ź�;font-size:14px;">������</span><span style="font-family:΢���ź�;color:#008b8b;font-size:14px;">' + name + '</span>' + splitor;
                htmlStr += '<span style="font-family:΢���ź�;font-size:14px;">�Ա�</span><span style="font-family:΢���ź�;color:#008b8b;font-size:14px;">' + gender + '</span>' + splitor;
                //htmlStr += '</div><div style="margin:3px">';
                htmlStr += '<span style="font-family:΢���ź�;font-size:14px;">��Ժ���ڣ�</span><span style="font-family:΢���ź�;color:#008b8b;font-size:14px;">' + admDate + '</span>' + splitor;
                htmlStr += '<span style="font-family:΢���ź�;font-size:14px;">��Ժ���ڣ�</span><span style="font-family:΢���ź�;color:#008b8b;font-size:14px;">' + disDate + '</span>' + splitor;
                htmlStr += '<span style="font-family:΢���ź�;font-size:14px;">��Ժ���ң�</span><span style="font-family:΢���ź�;color:#008b8b;font-size:14px;">' + admLoc + '</span>' + splitor;
                htmlStr += '<span style="font-family:΢���ź�;font-size:14px;">��Ժ���ң�</span><span style="font-family:΢���ź�;color:#008b8b;font-size:14px;">' + disLoc + '</span>' + splitor;
                htmlStr += '</div>';
                $('#infoPanel').append(htmlStr);
            }
            else {
                $.messager.alert(FSReviewView.Config.ERROR_INFO, FSReviewView.Config.ERROR_INFO_EPISODEINFO, 'error');
            }
        }

        function getSelectEpisode() {
            FSReviewView.SelectEpisode = episodeID;
        }

        function qcback(reason) {
            var obj = $.ajax({
                url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=qcback&EpisodeID=" + FSReviewView.SelectEpisode + "&UserID=" + userID + "&Reason=" + encodeURI(reason) + "&Back2Nur=" + FSReviewView.Back2Nur + "&Back2Doc=" + FSReviewView.Back2Doc,
                type: 'post',
                async: false
            });

            FSReviewView.Back2Doc = "0";
            FSReviewView.Back2Nur = "0";
            FSReviewView.SelectEpisode = "";

            var ret = obj.responseText;
            if (ret != "1") {
                $.messager.alert(FSReviewView.Config.ERROR_INFO, FSReviewView.Config.ERROR_INFO_QCBACK, 'error');
                return;
            }
            else {
                searchEpisode();
                FSReviewCommon.CloseWebPage();
            }
        }

        function searchEpisode() {
            window.dialogArguments.funObj.apply(this, []);
        }

    });
}(window));



      
