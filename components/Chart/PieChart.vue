<template>
  <div id="echart-pie" :style="{ width: '100%', height: '100%' }"></div>
</template>

<script>
import * as echarts from "echarts";

export default {
  methods: {
    initChart(pieData) {
      const chartDom = document.getElementById("echart-pie");
      const myChart = echarts.init(chartDom);
      const option = {
        title: {
          text: "Book Borrowing Type Analysis",
          left: "center",
        },
        tooltip: {
          trigger: "item",
        },
        legend: {
          orient: "vertical",
          left: "left",
        },
        series: [
          {
            name: "Book Borrowing Type Analysis",
            type: "pie",
            radius: "50%",
            data: pieData,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
      };

      option && myChart.setOption(option);
    },
  },
};
</script>

<style></style>