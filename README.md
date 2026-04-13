# Sant-Jordi-Jam-2026
Game Jam project for: https://itch.io/jam/sant-jordi-jam-2026

**Propiedades**
- **Estatus:** 🟢 En desarrollo (Sant Jordi Jam 2026)
- **Género:** Bullet Hell Top-Down / Rhythm Game Asimétrico
- **Plataforma:** WebGL (itch.io)
- **Motor:** CometEngine (AngelScript)

---

## 📖 1. Resumen del Proyecto

> **Elevator Pitch:** Un intrépido bardo se enfrenta a un dragón en una cueva. Con la mano izquierda (WASD), el jugador esquiva un *bullet hell* de fuego, refugiándose tras rocas que caen del techo. Con la mano derecha (Ratón), supera minijuegos rítmicos estilo *Osu!* para cargar su arpa mágica y contraatacar. Si recibe daño, el arpa cae al suelo y debe recuperarla bajo el fuego enemigo.

- **Estilo Visual:** Pixel Art (Vista Top-Down / Cenital).
- **Duración Estimada:** 5 - 10 minutos (aprox. 15 fases de ataque).

## 🎯 2. Adecuación a la Jam y Entregables

- **Tema ("Toda piedra hace pared"):** El techo de la cueva se derrumba progresivamente. Las rocas que caen actúan como coberturas dinámicas que el jugador debe usar estratégicamente para bloquear los proyectiles del dragón.
- **Entregable Juego:** Ejecutable WebGL centrado en la temática.
- **Entregable Rosa Virtual:** Al completar las fases, la melodía generada por los aciertos del jugador se exporta como la "Rosa" virtual para regalar a otro participante.

## ⚙️ 3. Mecánicas de Juego (Core Gameplay)

El juego exige coordinación asimétrica de ambas manos y se divide en un bucle de dos estados fluidos.

### 🛡️ 3.1. Fase de Supervivencia y Carga (Mano Izquierda - WASD)
- **Movimiento y Evasión:** El Bardo se mueve en 2D cenital. El Dragón (situado arriba) lanza patrones *bullet hell*.
- **Cobertura Dinámica (Las Rocas):** Caen rocas del techo telegrafiadas por sombras. Una vez aterrizan, actúan como muros sólidos que bloquean los proyectiles enemigos. Se destruyen tras recibir un número determinado de impactos.
- **Recolección de Munición:** Cuando el dragón ruge, expulsa "Notas Musicales" físicas por la arena. El jugador debe recogerlas para llenar el medidor del arpa.
- **Penalización (*The Textorcist* style):** El Bardo no tiene barra de vida clásica. Si un proyectil impacta, suelta el Arpa, que rebota a otra zona del mapa. Mientras está desarmado:
  - No puede recoger notas musicales.
  - No puede iniciar el ataque.
  - Su único objetivo es sobrevivir y llegar hasta el arpa para recuperarla.

### 🎵 3.2. Fase de Contraataque (Mano Derecha - Ratón)
- **Activación:** Al llenar el medidor de notas, se activa la fase ofensiva.
- **Minijuego Rítmico (*Osu!* style):** Durante 10 segundos, aparecen "Hit Circles" en la pantalla. El jugador debe mover el cursor y clicar en ellos al ritmo exacto de la música.
- **Resolución:**
  - *Éxito:* Cada acierto dispara un láser mágico hacia el dragón, restándole salud.
  - *Fallo:* Rompe el combo y reduce el daño total infligido en esa ronda.
  - *Mitigación:* Durante estos 10 segundos, la intensidad del *bullet hell* disminuye para permitir al jugador concentrarse en la puntería.

## ➕ 4. Progresión y Contenido

- **Fases del Jefe:** El dragón tiene 15 segmentos de vida, equivalentes a 15 rondas musicales para derrotarlo.
- **Escalada de Dificultad:** A medida que el dragón recibe daño:
  - Los patrones de *bullet hell* se vuelven más densos y agresivos.
  - Caen más rocas, alterando drásticamente la topografía y las rutas de escape.
  - Los minijuegos aumentan su velocidad (BPM) y complejidad.

## 🎨 5. Arte y Audio

- **Perspectiva:** *Top-Down* (ej. *Enter the Gungeon*).
- **Diseño de Entorno:** Cueva oscura iluminada dinámicamente por las llamas y los láseres del arpa.
- **Música (Vital):** Soundtrack con *beats* muy marcados para que el minijuego sea justo. Las notas recogidas y los láseres disparados se sincronizan tonalmente con la pista principal.

## 🖥️ 6. Interfaz de Usuario (UI/UX)

- **HUD Principal:**
  - Barra de vida del Dragón (dividida en 15 segmentos) en la parte superior.
  - Medidor de "Carga del Arpa" integrado visualmente cerca del Bardo.
- **UI de Combate:** Retícula del ratón en color neón o alto contraste para no perderla entre las explosiones.
- **Feedback Visual:** Parpadeo rojo en pantalla y pérdida de brillo en el sprite del personaje al quedar desarmado.

## 💻 7. Especificaciones Técnicas

- **Motor:** CometEngine.
- **Lenguaje:** AngelScript.
- **Colisiones y Físicas:** Manejo de colisiones en 2D estricto (AABB o Circle Colliders) para proyectiles, rocas, jugador y el arpa en el suelo.
- **Sincronización de Audio:** Implementación de *timestamps* preprogramados en arrays para coordinar la aparición exacta de los círculos interactivos en la fase rítmica.