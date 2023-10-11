/* globals zip, document, URL, MouseEvent, AbortController, alert */

(() => {	
	var url = document.URL.toString();
	var unitID=(url ? ((url.split("?")[1])? url.split("?")[1].split("=")[1] :""):"");
	
	const model = (() => {      
		let zipWriter;
		return {
			addFile(file, options) {
				if (!zipWriter) {
					zipWriter = new zip.ZipWriter(new zip.BlobWriter("application/zip"));
				}
				return zipWriter.add(file.name, new zip.BlobReader(file), options);
			},
			async getBlobURL() {
				if (zipWriter) {
					const blobURL = URL.createObjectURL(await zipWriter.close());
					zipWriter = null;
					return blobURL;
				} else {
					throw new Error("Zip file closed");
				}
			}
		};

	})();

	(() => {
		
		const fileInput = document.getElementById("file-input");
		const fileInputButton = document.getElementById("file-input-button");
		const zipProgress = document.createElement("progress");
		const downloadButton = document.getElementById("btnDownload");
		const fileList = document.getElementById("file-list");

		fileInputButton.addEventListener("click", () => fileInput.dispatchEvent(new MouseEvent("click")), false);
		downloadButton.addEventListener("click", onDownloadButtonClick, false);
		fileInput.onchange = selectFiles;
	
		async function selectFiles() {
			try {
				await addFiles();
				fileInput.value = "";
				$('#btnDownload').linkbutton('enable');
			} catch (error) {
				if(error.message=='File already exists') {
					$.messager.alert('提示','文件已存在！','info');
				}else {
					$.messager.alert('提示',error,'info');
				}
				return;
			} finally {
				zipProgress.remove();
			}
		}
        
		async function addFiles() {
			$('#btnDownload').linkbutton('disable');
			await Promise.all(Array.from(fileInput.files).map(async file => {
				const li = document.createElement("li");
				const filenameContainer = document.createElement("span");
				const filename = document.createElement("span");
				const zipProgress = document.createElement("progress");
				filenameContainer.classList.add("filename-container");
				li.appendChild(filenameContainer);
				filename.classList.add("filename");
				filename.textContent = file.name;
				filenameContainer.appendChild(filename);
				zipProgress.value = 0;
				zipProgress.max = 0;
				li.appendChild(zipProgress);
				fileList.classList.remove("empty");
				fileList.appendChild(li);
				li.title = file.name;
				li.classList.add("pending");
				const controller = new AbortController();
				const signal = controller.signal;
				const abortButton = document.createElement("button");
				abortButton.onclick = () => controller.abort();
				abortButton.textContent = "✖";
				abortButton.title = "Abort";
				filenameContainer.appendChild(abortButton);
				
				try {
					const entry = await model.addFile(file, {
						bufferedWrite: true,
						password: unitID,
						signal,
						onprogress: (index, max) => {
							li.classList.remove("pending");
							li.classList.add("busy");
							zipProgress.value = index;
							zipProgress.max = max;
						},
					});
					li.title += `\n  Last modification date: ${entry.lastModDate.toLocaleString()}\n  Compressed size: ${entry.compressedSize.toLocaleString()} bytes`;
				} catch (error) {
					if (error.message == zip.ERR_ABORT) {
						if (!li.previousElementSibling && !li.nextElementSibling) {
							fileList.classList.add("empty");
						}
						li.remove();
					} else {
						throw error;
					}
				} finally {
					li.classList.remove("busy");
					zipProgress.remove();
				}
			}));
		}

		async function onDownloadButtonClick(event) {
			
			let blobURL;
			try {
				blobURL = await model.getBlobURL();
			} catch (error) {
				$.messager.alert('提示',error,'info');
				return;
			}
			if (blobURL) {
				const anchor = document.createElement("a");
				const clickEvent = new MouseEvent("click");
				anchor.href = blobURL;
				anchor.download = "NIDP-"+new Date().getTime()*1000+ '.zip';
				anchor.dispatchEvent(clickEvent);
				fileList.innerHTML = "";
				fileList.classList.add("empty");
				
			}
			$('#btnDownload').linkbutton('disable');
			event.preventDefault();
			websys_showModal('close');  //关闭当前窗窗口	
		}

	})();

})();
