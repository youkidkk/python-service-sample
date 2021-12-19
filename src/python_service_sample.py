import logging
import logging.config
import signal
import time

import yaml

with open("./config/log_config.yml") as log_conf_file:
    log_yml = yaml.safe_load(log_conf_file)
    logging.config.dictConfig(log_yml)
    logger = logging.getLogger(__name__)


alive = True


def signal_handler(signum, _):
    global alive
    logger.info(f"signal={signum}")
    alive = False


def main():
    while alive:
        logger.info("Python service sample is alive...")
        time.sleep(1.0)
    logger.info("Python service sample end.")


if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    main()
