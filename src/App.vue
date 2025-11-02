
<template>
  <!-- 導航列 -->
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
      <a class="navbar-brand" href="#" onclick="return false;">
        <strong>厚陞揚社區</strong>
      </a>
      <button
        class="navbar-toggler"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#navbarNav"
        aria-controls="navbarNav"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item">
            <a class="nav-link active" href="#" data-tab="home">停車位置配置圖</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" data-tab="about">機車格位表</a>
          </li>
          <!-- <li class="nav-item">
            <a class="nav-link" href="#" data-tab="services">服務項目</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" data-tab="contact">聯絡我們</a>
          </li> -->
        </ul>
      </div>
    </div>
  </nav>

  <!-- 內容區域 -->
  <div class="content-wrapper">
    <div class="container">
      <div class="tab-content">
        <!-- 首頁 -->
        <div class="tab-pane active" id="home">
          <div class="row">
            <div class="col-12">
              <img src="./assets/B1.png" style="width:100%" />
              <img src="./assets/B2.png" style="width:100%" />
            </div>
          </div>

        </div>

        <!-- 關於我們 -->
        <div class="tab-pane" id="about">
          <motorcycle />
        </div>

        <!-- 服務項目 -->
        <div class="tab-pane" id="services">
          <div class="text-center mb-4 mb-md-5">
            <h2 class="display-4 fw-bold mb-3">我們的服務</h2>
            <p class="lead text-muted">提供全方位的專業服務</p>
          </div>
          <div class="row g-3 g-md-4">
            <div class="col-12 col-lg-6">
              <div class="card h-100 border-0 shadow-sm">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center mb-3">
                    <div class="display-6 me-3">📱</div>
                    <h4 class="mb-0">網站開發</h4>
                  </div>
                  <p class="text-muted mb-0">
                    打造響應式、高效能的網站，提供最佳的使用者體驗。從設計到開發，一站式服務。
                  </p>
                </div>
              </div>
            </div>
            <div class="col-12 col-lg-6">
              <div class="card h-100 border-0 shadow-sm">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center mb-3">
                    <div class="display-6 me-3">🎨</div>
                    <h4 class="mb-0">品牌設計</h4>
                  </div>
                  <p class="text-muted mb-0">
                    專業的視覺設計團隊，為您打造獨特的品牌形象，讓您在市場中脫穎而出。
                  </p>
                </div>
              </div>
            </div>
            <div class="col-12 col-lg-6">
              <div class="card h-100 border-0 shadow-sm">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center mb-3">
                    <div class="display-6 me-3">📊</div>
                    <h4 class="mb-0">數據分析</h4>
                  </div>
                  <p class="text-muted mb-0">
                    深入分析業務數據，提供有價值的洞察，協助您做出更明智的決策。
                  </p>
                </div>
              </div>
            </div>
            <div class="col-12 col-lg-6">
              <div class="card h-100 border-0 shadow-sm">
                <div class="card-body p-4">
                  <div class="d-flex align-items-center mb-3">
                    <div class="display-6 me-3">🔧</div>
                    <h4 class="mb-0">技術支援</h4>
                  </div>
                  <p class="text-muted mb-0">
                    提供全天候的技術支援服務，確保您的系統運行順暢，問題快速解決。
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 聯絡我們 -->
        <div class="tab-pane" id="contact">
          <div class="row justify-content-center">
            <div class="col-12 col-lg-8">
              <div class="text-center mb-4 mb-md-5">
                <h2 class="display-4 fw-bold mb-3">聯絡我們</h2>
                <p class="lead text-muted">有任何問題嗎？我們很樂意為您服務</p>
              </div>
              <div class="card border-0 shadow-lg">
                <div class="card-body p-4 p-md-5">
                  <form id="contactForm">
                    <div class="mb-3 mb-md-4">
                      <label class="form-label fw-bold">姓名</label>
                      <input
                        type="text"
                        class="form-control form-control-lg"
                        placeholder="請輸入您的姓名"
                        required
                      />
                    </div>
                    <div class="mb-3 mb-md-4">
                      <label class="form-label fw-bold">電子郵件</label>
                      <input
                        type="email"
                        class="form-control form-control-lg"
                        placeholder="example@email.com"
                        required
                      />
                    </div>
                    <div class="mb-3 mb-md-4">
                      <label class="form-label fw-bold">主旨</label>
                      <input
                        type="text"
                        class="form-control form-control-lg"
                        placeholder="請輸入主旨"
                        required
                      />
                    </div>
                    <div class="mb-3 mb-md-4">
                      <label class="form-label fw-bold">訊息內容</label>
                      <textarea
                        class="form-control"
                        rows="5"
                        placeholder="請輸入您的訊息..."
                        required
                      ></textarea>
                    </div>
                    <div class="d-grid">
                      <button type="submit" class="btn btn-primary btn-lg">
                        送出訊息
                      </button>
                    </div>
                  </form>
                </div>
              </div>
              <div class="row mt-4 mt-md-5 g-3 g-md-4">
                <div class="col-12 col-md-4 text-center">
                  <div class="display-6 mb-2">📍</div>
                  <h6 class="fw-bold">地址</h6>
                  <p class="text-muted small mb-0">台灣台北市中正區</p>
                </div>
                <div class="col-12 col-md-4 text-center">
                  <div class="display-6 mb-2">📧</div>
                  <h6 class="fw-bold">電子郵件</h6>
                  <p class="text-muted small mb-0">info@example.com</p>
                </div>
                <div class="col-12 col-md-4 text-center">
                  <div class="display-6 mb-2">📞</div>
                  <h6 class="fw-bold">電話</h6>
                  <p class="text-muted small mb-0">+886 2 1234 5678</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
body {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.content-wrapper {
  min-height: calc(100vh - 56px);
  background: white;
  margin-top: 56px;
}
.tab-content {
  padding: 2rem 0;
}
.feature-card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  height: 100%;
}
.feature-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
}
.navbar {
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}
.tab-pane {
  display: none;
}
.tab-pane.active {
  display: block;
}
@media (max-width: 768px) {
  .tab-content {
    padding: 1rem 0;
  }
  .display-3 {
    font-size: 2rem;
  }
  .display-4 {
    font-size: 1.75rem;
  }
}
</style>


<script setup>
import { ref } from 'vue'
import motorcycle from './components/motorcycle.vue'


</script>
