export const config = {
  settings: {
    ped: {
      take: {
        targetLabel: 'Take a task',
        targetIcon: 'fa-solid fa-circle',
        distance: 1.0
      },
      abort: {
        targetLabel: 'Abort the task',
        targetIcon: 'fa-solid fa-xmark',
        distance: 1.0
      }
    },
    task: {
      notify: {
        take: 'I have setted a waypoint for you in the map',
        abort: 'Task Aborted',
        progressBar: 'Picking up package...',
        title: 'Delivery',
        success: 'You picked up the package!',
        canceled: 'Canceled',
        description: 'You canceled picking up the package.'
      },
      target: {
        label: 'Open the box',
        icon: 'fa-solid fa-box',
        distance: 1.5
      },
      propModel: `prop_cs_package_01`
    },
    blipWaypoint: {
      sprite: 543,
      color: {
        route: 1,
        blip: 1
      },
      scale: 0.9,
      label: 'Anonymous'
    }
  },
  taskCoords: [
    [522.43, 198.49, 107.31],
    [584.08, 138.19, 98.47],
    [971.46, -95.89, 74.31],
    [1192.5, -1249.22, 39.32],
    [814.02, -491.28, 30.52],
    [1221.41, 333.76, 82.11],
    [-1363.22, 362.93, 63.76],
    [-1792.98, 158.06, 66.58],
    [-1286.53, 4497.34, 14.74],
    [-1632.98, 4735.9, 52.31],
    [10.38, 3736.92, 39.52],
    [-164.93, 6139.83, 31.21],
    [-86.79, 6368.98, 32.38],
    [-105.77, 6528.71, 29.17],
    [1700.97, 4868.5, 41.85],
    [2016.15, 4986.96, 41.1],
  ],
  peds: [
    {
      model: 'g_m_importexport_01',
      scenario: 'WORLD_HUMAN_LEANING',
      coords: [-2213.64, -371.48, 13.32, 39.33],
    },
    {
      model: 'g_m_m_armboss_01',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [1075.89, -2358.9, 30.28, 261.78],
    },
    {
      model: 'g_m_y_ballaeast_01',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [545.97, -2690.91, 6.22, 3.52],
    },
    {
      model: 'g_m_y_ballaorig_01',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [1459.76, 1043.43, 112.33, 272.81],
    },
    {
      model: 'g_m_y_ballasout_01',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [-1844.91, 223.29, 84.44, 308.06],
    },
    {
      model: 'g_m_y_lost_01',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [793.74, 537.9, 126.11, 142.59],
    },
    {
      model: 'g_m_y_mexgoon_03',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [1661.04, -26.0, 17377, 116.52],
    },
    {
      model: 'g_m_y_salvaboss_01',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [-957.23, -1566.86, 5.02, 106.8],
    },
    {
      model: 'g_m_y_mexgoon_02',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [164.83, 2226.22, 90.87, 51.62],
    },
    {
      model: 'g_m_y_armgoon_02',
      scenario: 'WORLD_HUMAN_STAND_FISHING',
      Coords: [713.28, 4092.59, 35.73, 179.51],
    },
    {
      model: 'g_m_y_korean_02',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [-2165.67, 5196.09, 16.88, 58.42],
    },
    {
      model: 'g_m_m_chicold_01',
      scenario: 'WORLD_HUMAN_LEANING',
      Coords: [445.96, 6463.31, 28.78, 54.34],
    },
  ],
  items: {
    ['itemName']: {
      percentage: 0,
      amount: 0
    },
  }
}