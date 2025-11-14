<template>
  <div class="container-fluid py-4">
    <div class="table-container">
      <div class="action-buttons">
        <button @click="openModal" class="btn btn-warning">抽車位</button>
        <button @click="saveData" class="btn btn-primary">儲存</button>
        <button @click="clearAllSlots" class="btn btn-danger">清除所有車位</button>
        <button @click="downloadJPG" class="btn btn-success">下載 JPG</button>
        <button @click="downloadExcel" class="btn btn-info">下載 Excel</button>
        <input
          type="date"
          v-model="tableDate"
          class="date-input"
          style="background: #fff"
          disabled
        />
      </div>

      <div v-if="loading" class="text-center my-5">
        <div class="spinner-border" role="status">
          <span class="visually-hidden">載入中...</span>
        </div>
      </div>

      <div v-else id="capture-area">
        <h1>厚陞揚 社區——機車格位表</h1>

        <div class="table-responsive">
          <table class="table table-bordered parking-table">
            <thead>
              <tr>
                <th style="width: 80px">戶別</th>
                <th>第一<br />車位</th>
                <th>第二<br />車位</th>
                <th style="width: 80px">戶別</th>
                <th>第一<br />車位</th>
                <th>第二<br />車位</th>
                <th style="width: 80px">戶別</th>
                <th>第一<br />車位</th>
                <th>第二<br />車位</th>
                <th style="width: 80px">戶別</th>
                <th>第一<br />車位</th>
                <th>第二<br />車位</th>
                <th style="width: 80px">戶別</th>
                <th>第一<br />車位</th>
                <th>第二<br />車位</th>
              </tr>
            </thead>
            <tbody>
       
              <tr v-for="(row, rowIndex) in parkingData" :key="row.id">
                <template v-for="(unit, idx) in row.units" :key="idx">
                  <td
                    :class="[
                      'zone-' + row.zones[idx],
                      disputeUnits.includes(unit) ? 'dispute-cell' : '',
                    ]"
                  >
                    <input type="text" class="parking-input" v-model="row.units[idx]" />
                  </td>
                  <td
                    class="parking-cell"
                    :class="[row.occupied[idx]?.first ? 'occupied' : '']"
                  >
                    <input type="text" class="parking-input" v-model="row.first[idx]" />
                  </td>
                  <td
                    class="parking-cell"
                    :class="[row.occupied[idx]?.second ? 'occupied' : '']"
                  >
                    <input type="text" class="parking-input" v-model="row.second[idx]" />
                  </td>
                </template>
              </tr>
            </tbody>
          </table>
        </div>

        <div v-if="yellowWinners.length" class="mt-4">
          <h4 class="text-center text-warning mb-3">🏍️ 黃牌重機車位名單</h4>
          <table class="table table-bordered text-center">
            <thead>
              <tr class="table-warning">
                <th>住戶</th>
                <th>車位號碼</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, i) in yellowWinners" :key="i">
                <td>{{ item.unit }}</td>
                <td>{{ item.slot }}</td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="date-info">{{ formatDate(tableDate) }}製表</div>
      </div>
    </div>

    <!-- 🚗 抽車位彈跳視窗 -->
    <div v-if="showModal" class="modal-backdrop">
      <div class="modal-content">
        <div class="left">
          <h5>住戶名單</h5>
          <div class="mb-2">
            <button
              class="btn btn-sm btn-outline-primary"
              @click="toggleSelectAll('all')"
            >
              全選
            </button>
            {{ "" }} {{ "" }}
            <button
              class="btn btn-sm btn-outline-primary"
              @click="toggleSelectAll('fall')"
            >
              全不選
            </button>
          </div>
          <div class="scroll-list">
            <template v-if="step === 1">
            <template  v-for="unit in allUnits.slice().sort((a, b) => {
                  const [aPrefix, aNum] = a.split('-');
                  const [bPrefix, bNum] = b.split('-');

                  if (aPrefix !== bPrefix) return aPrefix.localeCompare(bPrefix);
                  return parseInt(aNum) - parseInt(bNum);
                })"
                  
                :key="unit">
              <label
             v-if="unit !== ''"
               
                class="d-block"
              >

                <input type="checkbox" v-model="disputeUnits" :value="unit" />
                {{ unit }}
              
              </label>
            </template>
            </template>
            <template v-else-if="step === 3">
              <template v-for="unit in allUnits.slice().sort((a, b) => {
                  const [aPrefix, aNum] = a.split('-');
                  const [bPrefix, bNum] = b.split('-');

                  if (aPrefix !== bPrefix) return aPrefix.localeCompare(bPrefix);
                  return parseInt(aNum) - parseInt(bNum);
                })" :key="unit">
                <label v-if="disputeUnits.includes(unit)" class="d-block" >
                  <input  type="checkbox" v-model="selectedUnits" :value="unit" disabled :disabled="isYellow(unit)" />
                  {{ unit }}
                </label>
                <label v-else-if="unit !== ''" class="d-block" >
                  <input  type="checkbox" v-model="firstPickUnits" :value="unit" :disabled="isYellow(unit)" />
                  {{ unit }}
                </label>
              </template>
            </template>
            <template v-else>
            <template v-for="unit in allUnits.slice().sort((a, b) => {
                  const [aPrefix, aNum] = a.split('-');
                  const [bPrefix, bNum] = b.split('-');

                  if (aPrefix !== bPrefix) return aPrefix.localeCompare(bPrefix);
                  return parseInt(aNum) - parseInt(bNum);
                })" :key="unit">
              <label  v-if="unit !== ''"  class="d-block">
                <input  type="checkbox" v-model="selectedUnits" :value="unit" />
                {{ unit }}
              </label>
            </template>
            </template>
          </div>
        </div>

        <div class="right">
          <h5>步驟 {{ step }} / 4</h5>
          <!-- 步驟 1：指派爭議 -->
          <div v-if="step === 1">
            <h6>
              ⚠️ 選擇爭議車位（共
              {{ disputeSlots.length }} 個爭議車位(1,2,9,10,12,14,24,25,26,27)）
            </h6>
            <div class="scroll-list">
            <template v-for="unit in disputeUnits"
                :key="unit">
              <label
              v-if="unit !== ''"
                
                class="d-flex justify-content-between align-items-center mb-1"
              >
                <div>
                  {{ unit }}
                </div>
                <div class="text-muted">
                  <!-- 顯示對應車位 -->
                  車位：{{ getDisputeSlot(unit) || "-" }}
                </div>
              </label>
            </template>

            </div>
            <button class="btn btn-primary mt-3" @click="assignDisputeSlots">
              指派完成 → 下一步
            </button>
          </div>

          <!-- 步驟 2：抽黃牌 -->
          <div v-if="step === 2">
            <h6>🎯 抽黃牌車位 (53, 72, 82)</h6>
            <button class="btn btn-success" @click="drawYellowSlots">開始抽黃牌</button>
            <ul class="mt-3">
              <hr />
              <li v-for="r in results" :key="r.unit">
                {{ r.unit }} → {{ r.slot || r.status }}
              </li>
            </ul>
            <template v-if="results.length > 0">
              <button
                class="btn btn-primary mt-3"
                @click="
                  step = 3;
                  clearResults();
                "
              >
                指派完成 → 下一步
              </button>
            </template>
          </div>

          <!-- 步驟 3：抽第一車位 -->
          <div v-if="step === 3">
            <h6>抽第一車位</h6>
            <div class="scroll-list" style="max-height: 135px">
              <label v-if="unit !== ''" v-for="unit in firstPickUnits" :key="unit" class="d-block">
                {{ unit }}
                <span v-if="disputeUnits.includes(unit)" class="text-muted"
                  >（爭議戶，無法抽第一車位）</span
                >
              </label>
            </div>
            <button class="btn btn-success mt-2" @click="drawFirstSlotsAnimated">
              開始抽第一車位
            </button>
            <ul class="mt-3" style="max-height: 125px; overflow: auto">
              <li v-for="r in results" :key="r.unit">
                {{ r.unit }} → {{ r.slot || r.status }}
              </li>
            </ul>
            <template v-if="test01">
              <button
                class="btn btn-primary mt-3"
                @click="
                  step = 4;
                  clearResults();
                  selectedUnits = ['B1-07','A1-11','B1-05','B1-08','A1-03','B1-04','A3-05','A2-10','A3-04','B1-06','A3-08','A2-15','B2-03','A1-09','A1-04','A1-05','B2-13','B2-06','A1-08','A2-14','A2-05','B1-13'];
                "
              >
                指派完成 → 下一步
              </button>
            </template>
          </div>

          <!-- 步驟 4：抽第二車位 -->
          <div v-if="step === 4">
            <h6>🅿️ 抽第二車位</h6>
            <button class="btn btn-success" @click="drawSecondSlotsAnimated">
              開始抽第二車位
            </button>
            <ul class="mt-3">
              <li v-for="r in results" :key="r.unit">
                {{ r.unit }} → {{ r.slot || r.status }}
              </li>
            </ul>
          </div>

          <div class="mt-4 d-flex justify-content-between">
            <button class="btn btn-secondary" @click="prevStep" v-if="step > 1">
              上一步
            </button>
            <button class="btn btn-dark" @click="closeModal">關閉</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import html2canvas from "html2canvas";
import * as XLSX from "xlsx";
import draggable from "vuedraggable";

// 狀態管理
const loading = ref(false);
const today = new Date();
const formattedDate = today.toISOString().split("T")[0];
const tableDate = ref(formattedDate);

// 基本資料
const parkingData = ref(
  [...Array(13)].map((_, i) => {
    // B1 號碼：第一格空白，之後 B1-02 到 B1-13
    const b1Number = i === 0 ? "" : `B1-${String(i + 1).padStart(2, "0")}`;

    return {
      id: i + 1,
      units: [
        `A1-${String(i + 3).padStart(2, "0")}`,
        `A2-${String(i + 3).padStart(2, "0")}`,
        `A3-${String(i + 3).padStart(2, "0")}`,
        b1Number, // ✅ 第一格空白，之後才是 B1-02 ~ B1-13
        `B2-${String(i + 1).padStart(2, "0")}`,
      ],
      zones: ["a1", "a2", "a3", "b1", "b2"],
      first: ["", "", "", "", ""],
      second: ["", "", "", "", ""],
      occupied: Array(5).fill({ first: false, second: false }),
    };
  })
);

// 切換全選 / 全不選
const toggleSelectAll = (value) => {
  if (value == "all") {
    if (step.value == 1) {
      disputeUnits.value = [...allUnits.value];
    }
    if (step.value == 2 || step.value == 4) {
      selectedUnits.value = [...allUnits.value];
    }

    if (step.value == 3) {
      const C = allUnits.value.filter((item) => !disputeUnits.value.includes(item));
      firstPickUnits.value = [...C];
    }
  }
  if (value == "fall") {
    if (step.value == 1) {
      disputeUnits.value = [];
    }
    if (step.value == 2 || step.value == 4) {
      selectedUnits.value = [];
    }
    if (step.value == 3) {
      firstPickUnits.value = [];
    }
  }

  if (step.value === 3) {
    if (selectedUnits.value.length === allUnits.value.length) {
      selectedUnits.value = [];
    } else {
      selectedUnits.value = [...allUnits.value];
    }
  }
};

// 判斷是否是黃牌車戶
const isYellow = (unit) => {
  return yellowWinners.value.some((y) => y.unit === unit);
};


// 全部住戶清單（自動過濾空白）
const allUnits = computed(() =>
  parkingData.value.flatMap((row) => row.units).filter((u) => u && u.trim() !== "")
);
// 車位資料
const allSlots = Array.from({ length: 82 }, (_, i) => i + 1).filter((i) => i !== 11);

// 不抽籤的車格
const excludedSlots = [30, 31, 32, 33, 15];

// 爭議格（會被爭議戶直接指派）
const disputeSlots = [1, 2, 9, 10, 12, 14, 24, 25, 26, 27];
const yellowSlots = [53, 72, 82];

// 畫面控制
const showModal = ref(false);
const step = ref(1);
const selectedUnits = ref([]);
const disputeUnits = ref([]);
const yellowWinners = ref(JSON.parse(localStorage.getItem("yellowWinners") || "[]"));
const results = ref([]);

// 打開彈窗
const openModal = () => {
  selectedUnits.value = ['A1-13','B1-13'];
  disputeUnits.value = ['A1-07','B2-11','B1-06','B1-05','A2-07','A2-09','B2-10','B1-12','A1-03','B2-03'];
  showModal.value = true;
  step.value = 1;
  results.value = [];
};

// 取得爭議戶對應的車位
const getDisputeSlot = (unit) => {
  const idx = disputeUnits.value.indexOf(unit);
  if (idx !== -1 && disputeSlots[idx]) return disputeSlots[idx];
  return null;
};

const firstPickUnits = ref([]);

// 關閉彈窗
const closeModal = () => (showModal.value = false);

// 上一步
const prevStep = () => (step.value = Math.max(1, step.value - 1));

// 儲存資料
const saveData = () => {
  localStorage.setItem("parkingData", JSON.stringify(parkingData.value));
  localStorage.setItem("yellowWinners", JSON.stringify(yellowWinners.value));
  alert("資料已儲存");
};

// 格位處理
const saveSlot = (unit, type, slot) => {
  if (!unit || unit.trim() === "") return; // ⛔ 忽略空白戶
  for (const row of parkingData.value) {
    const idx = row.units.indexOf(unit);
    if (idx !== -1) {
      if (type === "first") row.first[idx] = slot;
      else row.second[idx] = slot;
    }
  }
};

// 抽籤工具
const randomPick = (arr, count) => {
  const shuffled = arr.slice().sort(() => 0.5 - Math.random());
  return shuffled.slice(0, count);
};

// 步驟1：指派爭議車位
const assignDisputeSlots = () => {
  disputeUnits.value.forEach((unit, i) => {
    const slot = disputeSlots[i];
    if (slot) saveSlot(unit, "first", slot);
  });
  alert("已指派爭議車位！");
  step.value = 2;
};

// 步驟2：黃牌車位
const drawYellowSlots = async () => {
  results.value = [];
  yellowWinners.value = [];

  // 複製一份 yellowSlots，用於隨機抽取且避免重複
  const availableSlots = [...yellowSlots];

  for (const unit of selectedUnits.value) {
    await new Promise((r) => setTimeout(r, 500));

    if (availableSlots.length === 0) break; // 如果沒有剩餘 slot 就停止

    // 隨機抽一個 slot
    const randomIndex = Math.floor(Math.random() * availableSlots.length);
    const slot = availableSlots[randomIndex];

    // 移除已抽到的 slot，避免重複
    availableSlots.splice(randomIndex, 1);

    // 更新資料
    saveSlot(unit, "first", slot);

    // 存入結果
    yellowWinners.value.push({ unit, slot });
    results.value.push({ unit, slot });
  }
};

function clearResults() {
  results.value = []; // ✅ 清空陣列
}
let test01 = ref(false);
// 步驟3抽第一車位（排除爭議戶與黃牌車主）
const drawFirstSlotsAnimated = async () => {
  results.value = [];

  const yellowUnits = yellowWinners.value.map((y) => y.unit); // ⛔ 黃牌戶

  const available = allSlots.filter(
    (s) =>
      !disputeSlots.includes(s) &&
      !yellowSlots.includes(s) &&
      !excludedSlots.includes(s)
  );
   // 抽的對象：非爭議戶 + 非黃牌戶
  const normalUnits = selectedUnits.value.filter(
    (u) => !disputeUnits.value.includes(u) && !yellowUnits.includes(u)
  );

  const picked = randomPick(available, normalUnits.length);

for (let i = 0; i < normalUnits.length; i++) {
    await new Promise((r) => setTimeout(r, 400));
    saveSlot(normalUnits[i], "first", picked[i]);
    results.value.push({ unit: normalUnits[i], slot: picked[i] });
  }
  test01.value = true
  console.log(results)
  alert("第一車位抽籤結束！");
  // step.value = 4;
};

// 步驟4：抽第二車位
const drawSecondSlotsAnimated = async () => {
  results.value = [];

  // 取得剩餘可用的車位
  let remaining = allSlots.filter(
    (s) =>
      !excludedSlots.includes(s) && // 排除不抽格
      !parkingData.value.some((row) => [...row.first, ...row.second].includes(s))
  );

  // 打亂剩餘的車位
  const shuffledRemaining = [...remaining].sort(() => Math.random() - 0.5);

  const totalToPick = selectedUnits.value.length;
  const picked = [];

  // 如果剩餘車位不足，用備取補上
  for (let i = 0; i < totalToPick; i++) {
    if (i < shuffledRemaining.length) {
      picked.push(shuffledRemaining[i]);
    } else {
      picked.push(`備取${i - shuffledRemaining.length + 1}`);
    }
  }

  // ✅ 再次隨機洗牌整份結果（包含備取）
  const finalPicked = [...picked].sort(() => Math.random() - 0.5);

  // 依序配給 selectedUnits
  for (let i = 0; i < selectedUnits.value.length; i++) {
    await new Promise((r) => setTimeout(r, 400));

    const unit = selectedUnits.value[i];
    const slot = finalPicked[i];

    saveSlot(unit, "second", slot);
    results.value.push({ unit, slot });
  }

  alert("🎉 所有抽籤完成！");
  closeModal();
};


// 清除所有
const clearAllSlots = () => {
  if (!confirm("確定清除所有車位與黃牌名單嗎？")) return;
  parkingData.value.forEach((row) => {
    row.first = ["", "", "", "", ""];
    row.second = ["", "", "", "", ""];
  });
  disputeUnits.value = [];
  yellowWinners.value = [];
  localStorage.removeItem("yellowWinners");
  localStorage.setItem("parkingData", JSON.stringify(parkingData.value));
  alert("所有資料已清除！");
};

// 格式化日期
const formatDate = (d) => {
  const dt = new Date(d);
  return `${dt.getFullYear()}年${dt.getMonth() + 1}月${dt.getDate()}日`;
};


const downloadJPG = async () => {
  const captureArea = document.getElementById("capture-area");
  if (!captureArea) return;

  try {
    const canvas = await html2canvas(captureArea, { scale: 2 });
    const link = document.createElement("a");
    link.href = canvas.toDataURL("image/jpeg", 1.0);
    link.download = `parking-${tableDate.value}.jpg`;
    link.click();
  } catch (err) {
    console.error("下載 JPG 失敗:", err);
    alert("下載 JPG 失敗！");
  }
};
const downloadExcel = () => {
  const wb = XLSX.utils.book_new();

  // 先建立表頭
  const header = [
    "戶別", "第一車位", "第二車位",
    "戶別", "第一車位", "第二車位",
    "戶別", "第一車位", "第二車位",
    "戶別", "第一車位", "第二車位",
    "戶別", "第一車位", "第二車位",
  ];

  // 轉換成表格格式（每列顯示 5 組戶別資料）
  const body = parkingData.value.map((row) => {
    const rowData = [];
    row.units.forEach((unit, idx) => {
      rowData.push(unit);
      rowData.push(row.first[idx] || "");
      rowData.push(row.second[idx] || "");
    });
    return rowData;
  });

  const ws = XLSX.utils.aoa_to_sheet([header, ...body]);
  XLSX.utils.book_append_sheet(wb, ws, "機車格位表");

  XLSX.writeFile(wb, `parking-${tableDate.value}.xlsx`);
};




</script>

<style scoped>
.table-container {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
.parking-table {
  font-size: 13px;
  width: 100%;
}
.parking-table th {
  background: #d9d9d9;
  text-align: center;
  vertical-align: middle;
  font-weight: 600;
  padding: 6px 3px;
  border: 1px solid #000;
  font-size: 12px;
}
.parking-table td {
  text-align: center;
  vertical-align: middle;
  padding: 6px 3px;
  border: 1px solid #000;
}
.zone-a1 {
  background-color: #7dc5fb;
}
.zone-a2 {
  background-color: #ffff99;
}
.zone-a3 {
  background-color: #c4c4c4;
}
.zone-b1 {
  background-color: #ff99cc;
}
.zone-b2 {
  background-color: #c4e9bc;
}
.parking-cell {
  background-color: #ffffff !important;
}
.occupied {
  background-color: #ff0000 !important;
}
input {
  color: #000;
}
.occupied input {
  background-color: #ff0000 !important;
  color: #fff;
  font-weight: bold;
}
.date-info {
  text-align: right;
  margin-top: 15px;
  font-size: 14px;
  color: #666;
}
.parking-input {
  width: 100%;
  border: none;
  text-align: center;
  padding: 4px;
  font-size: 13px;
  background-color: transparent;
}
.parking-input:focus {
  outline: 2px solid #0d6efd;
  background-color: #fff !important;
}
.action-buttons {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  align-items: center;
}
.date-input {
  padding: 8px 12px;
  border: 1px solid #ced4da;
  border-radius: 4px;
  font-size: 14px;
}
.spinner-border {
  width: 3rem;
  height: 3rem;
  color: #0d6efd;
}

/* modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}
.modal-window {
  background: #fff;
  padding: 20px;
  width: 90%;
  max-width: 1100px;
  border-radius: 8px;
}
.modal-content {
  display: flex;
  gap: 16px;
}
.left,
.right {
  flex: 1;
  border: 1px solid #ccc;
  padding: 10px;
  border-radius: 8px;
  max-height: 70vh;
  overflow: auto;
}
.scroll-list {
  max-height: 48vh;
  overflow-y: auto;
  padding: 6px;
  border-radius: 6px;
  background: #fff;
}
.scroll-list-sm {
  max-height: 160px;
  overflow-y: auto;
  border: 1px solid #ddd;
  background: #fff;
  padding: 6px;
  border-radius: 6px;
}

/* small visuals */
.result ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.table-warning th,
.table-warning td {
  background-color: #fff3cd !important;
}
.text-warning {
  color: #c47f00 !important;
}

.table-container {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
h1 {
  text-align: center;
  margin-bottom: 30px;
}
.parking-table th,
.parking-table td {
  text-align: center;
  border: 1px solid #000;
  font-size: 12px;
}
.zone-a1 {
  background-color: #7dc5fb;
}
.zone-a2 {
  background-color: #ffff99;
}
.zone-a3 {
  background-color: #c4c4c4;
}
.zone-b1 {
  background-color: #ff99cc;
}
.zone-b2 {
  background-color: #c4e9bc;
}
.parking-cell {
  background: #fff !important;
}
.occupied {
  background: #ff0000 !important;
}
.dispute-cell {
  background-color: #ffe5b4 !important;
}
.modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}
.modal-content {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  display: flex;
  flex-direction: row;
  gap: 20px;
  width: 80%;
  max-height: 80vh;
  overflow-y: auto;
}
.left,
.right {
  flex: 1;
}
.scroll-list {
  max-height: 400px;
  overflow-y: auto;
  border: 1px solid #ccc;
  padding: 8px;
  border-radius: 5px;
  background: #fafafa;
}
.drag-list {
  border: 1px dashed #999;
  min-height: 100px;
  padding: 8px;
  background: #f9f9f9;
  border-radius: 5px;
}
.drag-item {
  background: #e0e0e0;
  margin-bottom: 6px;
  padding: 6px;
  border-radius: 5px;
  cursor: grab;
  transition: all 0.2s;
}
.drag-item:hover {
  background: #d0d0d0;
}
.action-buttons {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}
.date-info {
  text-align: right;
  margin-top: 15px;
  font-size: 14px;
  color: #666;
}
/* ✅ 統一 checkbox 外觀為白色邊框、黑色勾選 */
input[type="checkbox"] {
  accent-color: #fff; /* 主要屬性：強制白色主題 */
  background-color: #fff;
  border: 1px solid #ccc;
  width: 16px;
  height: 16px;
}

input[type="checkbox"]:checked {
  accent-color: #0d6efd; /* 勾選後藍色 */
}

/* ✅ 讓 checkbox 的背景永遠是白的（防止 dark mode 強制變黑） */
@media (prefers-color-scheme: dark) {
  input[type="checkbox"] {
    background-color: #fff !important;
    accent-color: #0d6efd !important;
  }
}

/* ✅ 白色滾動條樣式（針對 WebKit 瀏覽器，如 Chrome / Edge） */
.scroll-list::-webkit-scrollbar {
  width: 10px;
}

.scroll-list::-webkit-scrollbar-track {
  background: #f5f5f5; /* 滾動條背景 */
  border-radius: 10px;
}

.scroll-list::-webkit-scrollbar-thumb {
  background-color: #ccc; /* 滾動條滑塊 */
  border-radius: 10px;
  border: 2px solid #f5f5f5;
}

.scroll-list::-webkit-scrollbar-thumb:hover {
  background-color: #999;
}

/* ✅ FireFox 專用滾動條樣式 */
.scroll-list {
  scrollbar-width: thin;
  scrollbar-color: #ccc #f5f5f5;
}

</style>
